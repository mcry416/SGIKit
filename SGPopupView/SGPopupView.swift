//
//  SGPopupView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/24.
//

import UIKit

/// Popop view, include orginzed forms and closure.
open class SGPopupView: NSObject {
    
    public enum ShowType {
        /// Only content view to show.
        case plain
        /// Close button and center title.
        case navigation
    }
    
    ///
    private lazy var backgroundView: UIView = self.createBackgroundView()
    ///
    public lazy var contentView: UIView = self.createContentView()
    ///
    private lazy var backButton: UIButton = self.createBackButton()
    ///
    private lazy var centerLabel: UILabel = self.createCenterLabel()

    public weak var delegate: SGPopupViewDelegate?
    
    private var showType: ShowType = .plain
    
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
        set { backgroundView.backgroundColor = newValue }
        get { backgroundView.backgroundColor ?? .black.withAlphaComponent(0.4) }
    }
    /// Content view background color.
    public var contentColor: UIColor {
        set { contentView.backgroundColor = newValue }
        get { contentView.backgroundColor ?? .white }
    }
    /// Title text color.
    public var titleColor: UIColor {
        set { centerLabel.textColor = newValue }
        get { centerLabel.textColor ?? .white }
    }
    /// Navigation style title.
    public var title: String {
        set { centerLabel.text = newValue }
        get { centerLabel.text ?? "" }
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
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(height: CGFloat, showType: ShowType = .plain) {
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

// MARK: - View.
extension SGPopupView{
    
    private func _initView(showType: ShowType){
        let window = UIApplication.shared.keyWindow

        delegate?.popupViewWillShow?(self)
        window?.addSubview(backgroundView)
        window?.addSubview(contentView)
        delegate?.popupViewDidShow?(self)
        
        switch showType {
        case .plain:
            break
        case .navigation:
            contentView.addSubview(backButton)
            contentView.addSubview(centerLabel)
        }
        
        self.contentView.alpha = 0
        self.backgroundView.alpha = 0
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2, options: .curveEaseInOut) {
            self.contentView.frame = CGRect(x: 0,
                                            y: kSCREEN_HEIGHT - self.height,
                                            width: kSCREEN_WIDTH,
                                            height: self.height)
            self.backgroundView.alpha = 1
            self.contentView.alpha = 1
        }

    }
    
    private func createBackgroundView() -> UIView{
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
    
    private func createContentView() -> UIView{
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
    
    private func createBackButton() -> UIButton{
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: R.general_close), for: .normal)
        button.frame = CGRect(x: k12, y: 5, width: 36, height: 39)
        button.addTarget(self, action: #selector(hideSGPopupView), for: .touchUpInside)
        return button
    }
    
    private func createCenterLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.frame = CGRect(x: kHALF_WIDTH - (200 / 2), y: 5, width: 200, height: 39)
        return label
    }
    
}

// MARK: - Event.
extension SGPopupView{
    
    @objc
    open func addSubview(_ view: UIView){
        self.contentView.addSubview(view)
    }
    
    @objc private func removeSGPopupView(){
        self.backgroundView.removeFromSuperview()
    }
    
    @objc open func hideSGPopupView(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 7, options: .curveEaseInOut) {
            self.contentView.frame = CGRect(x: 0,
                                            y: kSCREEN_HEIGHT,
                                            width: kSCREEN_WIDTH,
                                            height: self.height)
            self.contentView.alpha = 0
            self.backgroundView.alpha = 0
        } completion: { (true) in
            self.setCloseListener?()
        }

        delegate?.popupViewWillDismiss?(self)
        
        self.perform(#selector(self.removeSGPopupView), with: nil, afterDelay: 0.3)
        delegate?.popupViewDidDismiss?(self)
    }
    
}
