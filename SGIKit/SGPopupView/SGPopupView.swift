//
//  SGPopupView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/24.
//

import UIKit

/// Popop view, include orginzed forms and closure.
class SGPopupView: NSObject {
    
    private lazy var backgroundView: UIView = self.createBackgroundView()
    
    public lazy var contentView: UIView = self.createContentView()
    
    public weak var delegate: SGPopupViewDelegate?
    
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
    ///
    public var setOnClickListener: SetOnClickListener?
    ///
    public var setOnLongClickListener: SetOnLongClickListener?
    ///
    public var setCloseListener: SetCloseListener?

    override init() {
        super.init()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(height: CGFloat) {
        self.init()
        self.height = height
        _initView()
    }
    
    deinit {
        
    }

}

extension SGPopupView{
    
}

// MARK: - View.
extension SGPopupView{
    
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
    
    fileprivate func _initView(){
        let window = UIApplication.shared.keyWindow

        window?.addSubview(backgroundView)
        window?.addSubview(contentView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.contentView.frame = CGRect(x: 0,
                                            y: kSCREEN_HEIGHT - self.height,
                                            width: kSCREEN_WIDTH,
                                            height: self.height)
        }

    }
    
}

// MARK: - Event.
extension SGPopupView{
    
    @objc fileprivate func removeSGPopupView(){
        backgroundView.removeFromSuperview()
    }
    
    @objc func hideSGPopupView(){
        Log.debug("EXE @objc HIDE.")
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.contentView.frame = CGRect(x: 0,
                                            y: kSCREEN_HEIGHT,
                                            width: kSCREEN_WIDTH,
                                            height: self.height)
        } completion: { (true) in
            self.setCloseListener!()
        }

        self.perform(#selector(self.removeSGPopupView), with: nil, afterDelay: 0.3)
    }
    
}
