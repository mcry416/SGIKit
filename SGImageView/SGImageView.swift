//
//  SGImageView.swift
//  SGIKit
//
//  Created by MCRY416 iMac on 2021/12/19.
//

import UIKit
import AudioToolbox

open class SGImageView: UIView {
    
    private var imageView: UIImageView!
    
    // Store init frame to execute animation.
    private var initFrame: CGRect!
    
    /// SGImageView whether could be click or action animation.
    public var isEnableTouch: Bool = true
    
    /// SGImageView whether could be action vibrate when touched.
    public var isTouchShake: Bool = true
    
    private var _setOnImageClickListener: SetOnImageViewClickListener?
    /// Set on SGImageView click listener.
    public var setOnImageClickListener: SetOnImageViewClickListener?{
        set{
            _setOnImageClickListener = newValue
        }
        get{
            return _setOnImageClickListener
        }
    }

    private var _image: UIImage!
    /// SGImageView image, nil default.
    public var image: UIImage!{
        set{
            _image = newValue
            imageView.image = _image
        }
        get{
            return _image ?? UIImage()
        }
    }
    
    // When define frame, which will set frame of imageView.
    open override var frame: CGRect{
        willSet{
            if imageView == nil {
                imageView = UIImageView()
            }
        }
        didSet{
            initFrame = frame
            imageView.frame.size = CGSize(width: frame.width, height: frame.height)
        }
    }
    
    // MARK: - Override init.
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Make a zoom in animation for self when user touch SGImageView began.
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isEnableTouch {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear) {
                let zoomOutRect = CGRect(x: self.initFrame.width - (self.initFrame.width - 30) - 15,
                                         y: self.initFrame.height - (self.initFrame.height - 30) - 15,
                                         width: self.initFrame.width - 30,
                                         height: self.initFrame.height - 30)
                self.imageView.frame = zoomOutRect
            }
            // Shake lightly when user touch SGImageView.
            if isTouchShake {
                let gen = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
                gen.prepare()
                gen.impactOccurred()
            }
        }
    }
    
    // Make a zoom out animation for self when user touch SGImageView cancelled.
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isEnableTouch {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
                self.imageView.frame = CGRect(x: 0,
                                              y: 0,
                                              width: self.initFrame.width,
                                              height: self.initFrame.height)
            }
        }
    }
    
    // Make a zoom out animation for self when user touch SGImageView ended.
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isEnableTouch {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
                self.imageView.frame = CGRect(x: 0,
                                              y: 0,
                                              width: self.initFrame.width,
                                              height: self.initFrame.height)
            }
            if setOnImageClickListener != nil {
                setOnImageClickListener!()
            }
        }
    }
    
}

extension SGImageView{
    
    public func setOnImageViewClickListener(listener: (() -> Void)?){
        self.setOnImageClickListener = {
            listener?()
        }
    }
    
}

extension SGImageView{
    
    // MARK: - Convenience init.
    /**
     Provide a dynamic animation instance for SGImageView.
     */
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
        setShadow()
        setImageView()
    }
    
    // Set shadow for layer.
    private func setShadow(){
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 6, height: 6)
        self.layer.shadowRadius = 10
    }
    
    // Set ImageView attributes.
    private func setImageView(){
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        self.addSubview(imageView)
    }
}
