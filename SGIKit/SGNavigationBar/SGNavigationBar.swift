//
//  SGNavigationBar.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/2/14.
//

import UIKit

class SGNavigationBar: UIView {
    
    let STATUS_BAR_HEIGHT: CGFloat = 20
    
    let HEIGHT: CGFloat = 44 + 20
    
    let CONTENT_WIDTH: CGFloat = 50
    
    let RIGHT_PADDING: CGFloat = 13
    
    private var _sg_barTintColor: UIColor = UIColor.white
    /// NavigationBar tint color.
    public var sg_barTintColor: UIColor? {
        set{
            _sg_barTintColor = newValue ?? UIColor.white
            self.backgroundColor = _sg_barTintColor
        }
        get{
            return _sg_barTintColor
        }
    }
    
    private var _sg_barBackgroundImage: UIImage?
    /// NavigationBar background image.
    public var sg_barBackgroundImage: UIImage?{
        set{
            _sg_barBackgroundImage = newValue ?? UIImage(named: "")
            self.backgroundColor = UIColor(patternImage: _sg_barBackgroundImage!)
        }
        get{
            return _sg_barBackgroundImage
        }
    }
    
    var context: UIViewController!

    private lazy var leftContent: UIView = self.createLeftView()
    private lazy var centerContent: UIView = self.createCenterView()
    private lazy var rightContent: UIView = self.createRightView()
    
    public lazy var leftButton: UIButton = self.createLeftButton()
//    private lazy var centerLabel: UILabel = self.createCenterLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        self.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: HEIGHT)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: HEIGHT)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SGNavigationBar {
    
    convenience init(leftView: UIView, centerView: UIView? = nil, rightView: UIView? = nil) {
        self.init()
        
        setupView(leftView: leftView, centerView: centerView, rightView: rightView)
    }
    
    private func setupView(leftView: UIView, centerView: UIView? = nil, rightView: UIView? = nil){
        // Avaliable leftView、centerView、rightView
        if centerView != nil && rightView != nil {
            assert(leftView.frame.size != CGSize(width: 0, height: 0), "Optional leftView must be defined and can not be CGSizeZero")
            assert(centerView!.frame.size != CGSize(width: 0, height: 0), "Optional centerView must be defined and can not be CGSizeZero")
            assert(rightView!.frame.size != CGSize(width: 0, height: 0), "Optional rightView must be defined and can not be CGSizeZero")
            
            self.addSubview(self.leftContent)
            self.addSubview(self.centerContent)
            self.addSubview(self.rightContent)
            self.leftContent.addSubview(leftView)
            self.centerContent.addSubview(centerView!)
            self.rightContent.addSubview(rightView!)
            leftView.center = CGPoint(x: self.leftContent.frame.width / 2, y: self.leftContent.frame.height / 2)
            centerView!.center = CGPoint(x: (self.frame.width / 2) - self.leftContent.frame.width, y: self.centerContent.frame.height / 2)
            rightView!.center = CGPoint(x: (CONTENT_WIDTH - RIGHT_PADDING - (rightView!.frame.width / 2)), y: self.rightContent.frame.height / 2)
        }
        // Avaliable leftView and rightView
        if centerView == nil && rightView != nil {
            assert(leftView.frame.size != CGSize(width: 0, height: 0), "Optional leftView must be defined and can not be CGSizeZero")
            assert(rightView!.frame.size != CGSize(width: 0, height: 0), "Optional rightView must be defined and can not be CGSizeZero")
            
            self.addSubview(self.leftContent)
            self.addSubview(self.rightContent)
            self.leftContent.addSubview(leftView)
            self.rightContent.addSubview(rightView!)
            leftView.center = CGPoint(x: self.leftContent.frame.width / 2, y: self.leftContent.frame.height / 2)
            rightView!.center = CGPoint(x: self.frame.width - RIGHT_PADDING - rightView!.frame.width, y: self.rightContent.frame.height / 2)
        }
        // Avaliable leftView and centerView
        if centerView != nil && rightView == nil {
            assert(leftView.frame.size != CGSize(width: 0, height: 0), "Optional leftView must be defined and can not be CGSizeZero")
            assert(centerView!.frame.size != CGSize(width: 0, height: 0), "Optional centerView must be defined and can not be CGSizeZero")
            
            self.addSubview(self.leftContent)
            self.addSubview(self.centerContent)
            self.leftContent.addSubview(leftView)
            self.centerContent.addSubview(centerView!)
            leftView.center = CGPoint(x: self.leftContent.frame.width / 2, y: self.leftContent.frame.height / 2)
            centerView!.center = CGPoint(x: (self.frame.width / 2) - self.leftContent.frame.width, y: self.centerContent.frame.height / 2)
        }

    }
    
    // MARK: - Lazy load.
    private func createLeftView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: STATUS_BAR_HEIGHT, width: CONTENT_WIDTH, height: HEIGHT - 20)
        view.isUserInteractionEnabled = true
        return view
    }
    
    private func createCenterView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: CONTENT_WIDTH, y: STATUS_BAR_HEIGHT, width: self.bounds.width - CONTENT_WIDTH * 2, height: HEIGHT - 20)
        return view
    }
    
    private func createRightView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: self.centerContent.frame.maxX, y: STATUS_BAR_HEIGHT, width: CONTENT_WIDTH, height: HEIGHT - 20)
        return view
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let tapViews: Array<UIView> = self.subviews
//        for tapView in tapViews {
//            let newPoint: CGPoint = self.convert(point, to: tapView)
//            if tapView.point(inside: newPoint, with: event) {
//                return tapView
//            }
//        }
//        return super.hitTest(point, with: event)
//    }
    
}

extension SGNavigationBar {
    
    // MARK: - Return button and title default.
    private func createLeftButton() -> UIButton{
        let button = UIButton()
        button.frame.size = CGSize(width: 24, height: 24)
        button.setImage(UIImage(named: "common_back_black_18"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        return button
    }
    
    private func createCenterLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.frame.size = CGSize(width: self.centerContent.bounds.width, height: HEIGHT)
        return label
    }
    
    @objc private func leftButtonAction(){
        self.context.navigationController?.popViewController(animated: true)
    }
    
}

