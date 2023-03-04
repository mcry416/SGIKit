//
//  SGNavigationBar.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/2/14.
//

import UIKit
import AVFAudio

/**
 SGNavigationBar to replace UINavigationBar, which is designed by inherited from UIView to show various view.
 */
class SGNavigationBar: UIView {
    
    typealias ClickAction = () -> Void
    
    // MARK: - Private constant.
    
    /// Left and right container width.
    private let CONTENT_WIDTH: CGFloat = 50
    /// Right view padding for right content.
    private let RIGHT_PADDING: CGFloat = 13
    /// Right button image name.
    private let RIGHT_IMAGE_NAME: String = "sg_navigationbar_back"
    /// Left button image name.
    private let LEFT_IMAGE_NAME: String = "sg_navigationbar_back"
    
    // MARK: - Set & get varibales.
    
    private var _barTintColor: UIColor = UIColor.white
    /// NavigationBar tint color.
    public var barTintColor: UIColor? {
        set{
            _barTintColor = newValue ?? UIColor.white
            self.backgroundColor = _barTintColor
        }
        get{
            return _barTintColor
        }
    }
    
    private var _barBackgroundImage: UIImage?
    /// NavigationBar background image.
    public var barBackgroundImage: UIImage?{
        set{
            _barBackgroundImage = newValue ?? UIImage(named: "")
            self.backgroundColor = UIColor(patternImage: _barBackgroundImage!)
        }
        get{
            return _barBackgroundImage
        }
    }
    
    private var _isBlur: Bool?
    /// NavigationBar whether should be presenting a blur view.
    public var isBlur: Bool? {
        set{
            _isBlur = newValue ?? false
            if _isBlur == true {
                self.effectView.isHidden = false
            } else {
                self.effectView.isHidden = true
            }
        }
        get{
            return _isBlur
        }
    }
    
    private var _isFullScreen: Bool = false
    /// NavigationBar whether should be override status bar.
    public var isFullScreen: Bool?{
        set{
            _isFullScreen = newValue!
            if _isFullScreen == true {
                self.resetFrameInFullScreen()
            } else {
                self.resetFrameInUnfullScreen()
            }
        }
        get{
            return _isFullScreen
        }
    }
    
    private var _isEnableDividerLine: Bool?
    /// NavigationBar whether should be show the divider line in the bottom.
    public var isEnableDividerLine: Bool?{
        set{
            _isEnableDividerLine = newValue ?? false
            if _isEnableDividerLine == true {
                self.addSubview(bottomLine)
            } else {
                if bottomLine.superview != nil {
                    bottomLine.removeFromSuperview()
                }
            }
        }
        get{
            return _isEnableDividerLine
        }
    }
    
    // MARK: - Private variables.
    
    private var leftActionClosure:   ClickAction?
    private var centerActionClosure: ClickAction?
    private var rightActionClosure:  ClickAction?

    private lazy var leftContent:      UIView = self.createLeftContent()
    private lazy var centerContent:    UIView = self.createCenterContent()
    private lazy var rightContent:     UIView = self.createRightContent()
    private lazy var bottomLine:       UIView = self.createBottomLine()
    private lazy var blurEffect: UIBlurEffect = self.createBlurEffect()
    private lazy var effectView: UIVisualEffectView = self.createEffectView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = CGRect(x: 0,
                            y: kSafeTopOffset(),
                            width: kScreenWidth(),
                            height: kNavigationBarHight())
        
        _ = self.effectView
        
        self.addSubview(self.leftContent)
        self.addSubview(self.centerContent)
        self.addSubview(self.rightContent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
//        if previousTraitCollection?.verticalSizeClass.rawValue == 1 {
//            _isFullScreen ? resetFrameInFullScreen() : resetFrameInUnfullScreen()
//        }
//        if previousTraitCollection?.verticalSizeClass.rawValue == 2 {
//            resetFrameInLandscape()
//        }
    }
    
}

// MARK: - Boot Convenience Init.
extension SGNavigationBar {
    
    convenience init(leftView: UIView? = nil, centerView: UIView? = nil, rightView: UIView? = nil) {
        self.init()
        
        setupView(leftView: leftView, centerView: centerView, rightView: rightView)
    }
    
    private func setupView(leftView: UIView? = nil, centerView: UIView? = nil, rightView: UIView? = nil){
        if leftView != nil {
            assert(leftView!.frame.size != .zero, "Optional leftView must be defined and can not be CGSizeZero")
            leftContent.addSubview(leftView!)
            leftView!.center = CGPoint(x: halfWidth(leftContent), y: halfHeight(leftContent))
        }
        if centerView != nil {
            assert(centerView!.frame.size != .zero, "Optional centerView must be defined and can not be CGSizeZero")
            centerContent.addSubview(centerView!)
            centerView!.center = CGPoint(x: halfWidth(self) - self.leftContent.frame.width, y: halfHeight(centerContent))
        }
        if rightView != nil {
            assert(rightView!.frame.size != .zero, "Optional rightView must be defined and can not be CGSizeZero")
            rightContent.addSubview(rightView!)
            rightView!.center = CGPoint(x: CONTENT_WIDTH - RIGHT_PADDING - halfWidth(rightView!), y: halfHeight(rightContent))
        }

    }
    
    private func createLeftContent() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: CONTENT_WIDTH, height: kNavigationBarHight())
        return view
    }
    
    private func createCenterContent() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: CONTENT_WIDTH, y: 0, width: self.bounds.width - (CONTENT_WIDTH * 2), height: kNavigationBarHight())
        return view
    }
    
    private func createRightContent() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: self.centerContent.frame.maxX, y: 0, width: CONTENT_WIDTH, height: kNavigationBarHight())
        return view
    }
    
    private func createBottomLine() -> UIView{
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        view.frame = CGRect(x: 0, y: kNavigationBarHight() - 0.5, width: kScreenWidth(), height: 0.5)
        return view
    }
    
    private func createBlurEffect() -> UIBlurEffect{
        let blurEffect = UIBlurEffect(style: .light)
        return blurEffect
    }
    
    private func createEffectView() -> UIVisualEffectView{
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = CGRect(x: self.frame.origin.x,
                                y: 0,
                                width: self.frame.width,
                                height: self.frame.height)
        self.addSubview(view)
        return view
    }
    
}

// MARK: - Outside method.
extension SGNavigationBar{
    
    public func scroll(_ x: CGFloat){
        let rate = x / UIScreen.main.bounds.width
        self.alpha = rate
    }
}

// MARK: - Inside method.
extension SGNavigationBar{
    
    private func resetFrameInFullScreen(){
        self.frame = CGRect(x: self.frame.origin.x,
                            y: 0,
                            width: self.frame.width,
                            height: self.frame.height + kSafeTopOffset())
        self.effectView.frame = CGRect(x: self.effectView.frame.origin.x,
                                       y: 0,
                                       width: self.effectView.frame.width,
                                       height: self.effectView.frame.height + kSafeTopOffset())
        self.leftContent.frame = CGRect(x: 0,
                                        y: 0,
                                        width: CONTENT_WIDTH,
                                        height: kNavigationBarHight())
        self.centerContent.frame = CGRect(x: self.leftContent.frame.maxX,
                                          y: 0,
                                          width: kScreenWidth() - (CONTENT_WIDTH * 2),
                                          height: self.centerContent.frame.height)
        self.rightContent.frame = CGRect(x: self.centerContent.frame.maxX,
                                         y: 0,
                                         width: CONTENT_WIDTH,
                                         height: self.rightContent.frame.height)
        self.bottomLine.frame = CGRect(x: 0,
                                       y: kNavigationBarHight() - 0.5,
                                       width: kScreenWidth(),
                                       height: 0.5)
    }
    
    private func resetFrameInUnfullScreen(){
        self.frame = CGRect(x: 0,
                            y: kStatusBarHeight(),
                            width: kScreenWidth(),
                            height: kNavigationBarHight())
        self.effectView.frame = CGRect(x: self.frame.origin.x,
                                       y: 0,
                                       width: self.frame.width,
                                       height: self.frame.height)
        self.leftContent.frame = CGRect(x: 0,
                                        y: 0,
                                        width: CONTENT_WIDTH,
                                        height: kNavigationBarHight())
        self.centerContent.frame = CGRect(x: CONTENT_WIDTH,
                                          y: 0,
                                          width: self.frame.width - (CONTENT_WIDTH * 2),
                                          height: kNavigationBarHight())
        self.rightContent.frame = CGRect(x: self.centerContent.frame.maxX,
                                         y: 0,
                                         width: CONTENT_WIDTH,
                                         height: kNavigationBarHight())
        self.bottomLine.frame = CGRect(x: 0,
                                       y: kNavigationBarHight() - 0.5,
                                       width: kScreenWidth(),
                                       height: 0.5)
        
        if self.leftContent.subviews.count > 0{
            let subviewOfLeft: UIView = self.leftContent.subviews[0]
            subviewOfLeft.frame = CGRect(x: 0,
                                         y: 0,
                                         width: self.leftContent.frame.width,
                                         height: self.leftContent.frame.height)
        }
        
        if self.centerContent.subviews.count > 0{
            let subviewOfCenter: UIView = self.centerContent.subviews[0]
            subviewOfCenter.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.centerContent.frame.width,
                                           height: self.centerContent.frame.height)
        }

    }
    
    private func resetFrameInLandscape(){
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: kScreenWidth(),
                            height: kNavigationBarHight())
        self.effectView.frame = CGRect(x: self.frame.origin.x,
                                       y: 0,
                                       width: self.frame.width,
                                       height: self.frame.height)
        self.leftContent.frame = CGRect(x: 0,
                                        y: 0,
                                        width: CONTENT_WIDTH,
                                        height: kNavigationBarHight())
        self.centerContent.frame = CGRect(x: CONTENT_WIDTH,
                                          y: 0,
                                          width: self.bounds.width - (CONTENT_WIDTH * 2),
                                          height: kNavigationBarHight())
        self.rightContent.frame = CGRect(x: self.centerContent.frame.maxX,
                                         y: 0,
                                         width: CONTENT_WIDTH,
                                         height: kNavigationBarHight())
        self.bottomLine.frame = CGRect(x: 0,
                                       y: kNavigationBarHight() - 0.5,
                                       width: kScreenWidth(),
                                       height: 0.5)
        
        if self.leftContent.subviews.count > 0{
            let subviewOfLeft: UIView = self.leftContent.subviews[0]
            subviewOfLeft.frame = CGRect(x: 0,
                                         y: 0,
                                         width: self.leftContent.frame.width,
                                         height: self.leftContent.frame.height)
        }
        
        if self.centerContent.subviews.count > 0{
            let subviewOfCenter: UIView = self.centerContent.subviews[0]
            subviewOfCenter.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.centerContent.frame.width,
                                           height: self.centerContent.frame.height)
        }
        
    }
    
}

// MARK: - Left button and center title.
extension SGNavigationBar {
    
    convenience init(title: String, leftText: String) {
        self.init()
        self.init(leftView: self.createLeftButton(text: leftText),
                  centerView: self.createCenterLabel(text: title),
                  rightView: nil)
    }
    
    private func createLeftButton(text: String) -> UIButton{
        let button = UIButton()
        button.frame.size = CGSize(width: 24, height: 24)
        if text != "" {
            button.setTitle(text, for: .normal)
        } else {
            button.setImage(UIImage(named: LEFT_IMAGE_NAME), for: .normal)
        }
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        return button
    }
    
    private func createCenterLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = SGColor.black()
        label.text = text
        label.frame.size = CGSize(width: self.centerContent.frame.width, height: kNavigationBarHight())
        return label
    }
    
    @objc private final func leftButtonAction(){
        if self.leftActionClosure != nil {
            leftActionClosure!()
        }
    }
    
    /**
     When click left area to callback this method.
     */
    public func setOnLeftClickListener(listener: ClickAction?){
        leftActionClosure = {
            if listener != nil {
                listener!()
            }
        }
    }
    
}

// MARK: - Left button and center title and right button.
// Some method use above extension content.
extension SGNavigationBar{
    
    /**
     Convenience generate a NavigationBar with three parameters.
     - Parameter title: Center text.
     - Parameter leftText: Left button title, input `""` to use image for button otherwise show the text parameter.
     - Parameter rightText: Right buttom title, input `""` to use image for button otherwise show the text parameter.
     */
    convenience init(title: String, leftText: String, rightText: String) {
        self.init()
        self.init(leftView: self.createLeftButton(text: leftText),
                  centerView: self.createCenterLabel(text: title),
                  rightView: self.createRightButton(text: rightText))
    }
    
    private func createRightButton(text: String) -> UIButton{
        let button = UIButton()
        button.frame.size = CGSize(width: 24, height: 24)
        if text != "" {
            button.setTitle(text, for: .normal)
        } else {
            button.setImage(UIImage(named: RIGHT_IMAGE_NAME), for: .normal)
        }
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        return button
    }

    @objc private final func rightButtonAction(){
        if self.rightActionClosure != nil {
            rightActionClosure!()
        }
    }
    
    /**
     When click right area to callback this method.
     */
    public func setOnRightClickListener(listener: ClickAction?){
        rightActionClosure = {
            if listener != nil {
                listener!()
            }
        }
    }
    
}

// MARK: - Frame Function.
extension SGNavigationBar{
    
    fileprivate final func kScreenWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    fileprivate final func kSafeTopOffset() -> CGFloat{
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }
    fileprivate final func kNavigationBarHight() -> CGFloat{
        let isFullScreen: Bool = (kSafeTopOffset() == 0) ? false : true
        let height: CGFloat = (isFullScreen == true) ? 44 : 50
        return height
    }
    fileprivate final func kStatusBarHeight() -> CGFloat{
        if #available(iOS 13.0, *) {
            let set: Set = UIApplication.shared.connectedScenes
            let sc = set.first
            let windowScene: UIWindowScene = (sc as? UIWindowScene)!
            let statusManager = windowScene.statusBarManager
            return statusManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    fileprivate final func halfWidth(_ v: UIView) -> CGFloat{
        return v.frame.width / 2
    }
    fileprivate final func halfHeight(_ v: UIView) -> CGFloat{
        return v.frame.height / 2
    }
}
