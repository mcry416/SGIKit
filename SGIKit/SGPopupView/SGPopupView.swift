//
//  SGPopupView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/24.
//

import UIKit

/// Popop view, include orginzed forms and closure.
class SGPopupView: NSObject {
    
    enum ShowType {
        /// Only content view to show.
        case Plain
        /// Close button and center title.
        case Navigation
        /// Root with scroll view.
        case Scroll
    }
    
    ///
    private lazy var backgroundView: UIView = self.createBackgroundView()
    ///
    public lazy var contentView: UIView = self.createContentView()
    ///
    private lazy var backButton: UIButton = self.createBackButton()
    ///
    private lazy var centerLabel: UILabel = self.createCenterLabel()
    ///
    private lazy var scrollView: UIScrollView = self.createScrollView()
    
    public weak var delegate: SGPopupViewDelegate?
    
    private var showType: ShowType = .Plain
    
    public final var height: CGFloat = 200{
        didSet{
//            self.contentView.frame = CGRect(x: self.contentView.frame.origin.x,
//                                            y: self.contentView.frame.origin.y,
//                                            width: self.contentView.frame.size.width,
//                                            height: self.height)
//            Log.debug("frame: \(self.contentView.frame)")
        }
    }
    /// Content view corner radius.
    public var cornerRadius: CGFloat = 15 {
        didSet{
            self.contentView.layer.cornerRadius = cornerRadius
        }
    }
    /// Skin background color.
    public var backgroundColor: UIColor?{
        didSet{
            self.backgroundView.backgroundColor = backgroundColor
        }
    }
    /// Content view background color.
    public var contentColor: UIColor?{
        didSet{
            self.contentView.backgroundColor = contentColor
        }
    }
    /// Navigation style title.
    public var title: String?{
        didSet{
            self.centerLabel.text = title
        }
    }
    /// Listen the SGPopupView when it
    public var setOnClickListener: SetOnClickListener?
    ///
    public var setOnLongClickListener: SetOnLongClickListener?
    /// Listen the SGPopupView when it was closed.
    public var setCloseListener: SetCloseListener?

    override init() {
        super.init()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(height: CGFloat, showType: ShowType = .Plain) {
        self.init()
        self.height = height
        
    //    delegate?.popupViewWillShow?(self)
        // Initlized view, showing.
        _initView(showType: showType)
   //     delegate?.popupViewDidShow?(self)
    }
    
    deinit {
        
    }

}

extension SGPopupView{
    
}

// MARK: - View.
extension SGPopupView{
    
    fileprivate func _initView(showType: ShowType){
        let window = UIApplication.shared.keyWindow

        delegate?.popupViewWillShow?(self)
        window?.addSubview(backgroundView)
        window?.addSubview(contentView)
        delegate?.popupViewDidShow?(self)
        
        switch showType {
        case .Plain:
            break
        case .Navigation:
            contentView.addSubview(backButton)
            contentView.addSubview(centerLabel)
        case .Scroll:
            contentView.addSubview(scrollView)
        default:
            break
        }
        
        self.contentView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.contentView.frame = CGRect(x: 0,
                                            y: kSCREEN_HEIGHT - self.height,
                                            width: kSCREEN_WIDTH,
                                            height: self.height)
            self.contentView.alpha = 1
        }

    }
    
    fileprivate func createBackgroundView() -> UIView{
        let view = UIView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        view.frame = UIApplication.shared.keyWindow?.bounds ?? .zero
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideSGPopupView))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        return view
    }
    
    fileprivate func createContentView() -> UIView{
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius

//        let maskPath = UIBezierPath(roundedRect: view.bounds,
//                                    byRoundingCorners: [.topLeft, .topRight],
//                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = view.bounds
//        maskLayer.path = maskPath.cgPath
//        view.layer.mask = maskLayer
        
        view.frame = CGRect(x: 0,
                            y: kSCREEN_HEIGHT,
                            width: kSCREEN_WIDTH,
                            height: self.height)
        
        return view
    }
    
    fileprivate func createBackButton() -> UIButton{
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: ""), for: .normal)
        button.frame = CGRect(x: k12, y: 5, width: 39, height: 39)
        return button
    }
    
    fileprivate func createCenterLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.frame = CGRect(x: kHALF_WIDTH - (200 / 2), y: 5, width: 200, height: 39)
        return label
    }
    
    fileprivate func createScrollView() -> UIScrollView{
        let scrollView = UIScrollView()
        scrollView.frame = contentView.bounds
        scrollView.contentSize = contentView.bounds.size
        return scrollView
    }
    
}

// MARK: - Event.
extension SGPopupView{
    
    @objc fileprivate func removeSGPopupView(){
        backgroundView.removeFromSuperview()
    }
    
    @objc func hideSGPopupView(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.contentView.frame = CGRect(x: 0,
                                            y: kSCREEN_HEIGHT,
                                            width: kSCREEN_WIDTH,
                                            height: self.height)
            self.contentView.alpha = 0
        } completion: { (true) in
            self.setCloseListener!()
        }

        delegate?.popupViewWillDismiss?(self)
        self.perform(#selector(self.removeSGPopupView), with: nil, afterDelay: 0.3)
        delegate?.popupViewDidDismiss?(self)
    }
    
}
