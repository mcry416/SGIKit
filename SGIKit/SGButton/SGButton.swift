//
//  SGButton.swift
//  NewNavigationBar
//
//  Created by MengQingyu iMac on 2022/2/10.
//

import UIKit

enum ImageLocation {
    case top
    case bottom
    case left
    case right
}

enum InitSource {
    case Text
    case TextImage
    case ParentView
}

class SGButton: UIButton{
    
    /// Store self background color when init.
    private var defaultBackgroundColor: UIColor!
    
    private var _setOnButtonClickListener: SetOnButtonClickListener?
    /// Set on SGButton click listener. Corresponding to it is touchUpInside in UIButton.Event.
    public var setOnButtonClickListener: SetOnButtonClickListener?{
        set{
            _setOnButtonClickListener = newValue
        }
        get{
            return _setOnButtonClickListener
        }
    }
    
    private var _setOnButtonTouchListener: SetOnButtonTouchListener?
    /// Set on SGButton touch listener. Corresponding to it is touchDown in UIButton.Event.
    public var setOnButtonTouchListener: SetOnButtonTouchListener?{
        set{
            _setOnButtonTouchListener = newValue
        }
        get{
            return _setOnButtonTouchListener
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
            let oldColorR = (self.backgroundColor?.cgColor)?.components![0] ?? 0
            let oldColorG = (self.backgroundColor?.cgColor)?.components![1] ?? 0
            let oldColorB = (self.backgroundColor?.cgColor)?.components![2] ?? 0
            let newColor = UIColor(red: oldColorR + 0.1, green: oldColorG + 0.1, blue: oldColorB + 0.1, alpha: 1)
            self.backgroundColor = newColor
        }
        
        self.sgButtonTouchUpInsideEvent()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
            self.backgroundColor = self.defaultBackgroundColor
        }
    }
    
    private func initAsSuper(_ title: String){
        self.setTitle(title, for: UIControl.State.normal)
    //    self.init
        self.setTitleColor(.systemBlue, for: UIControl.State.normal)
        self.setTitleColor(.systemGray, for: UIControl.State.highlighted)
    }
    
    @objc private func sgButtonTouchUpInsideEvent(){
        if setOnButtonClickListener != nil {
            setOnButtonClickListener!()
        }
    }
    
    @objc private func sgButtonTouchDownEvent(){
        if setOnButtonTouchListener != nil {
            setOnButtonTouchListener!()
        }
    }
}

// MARK: - Text Show Only.
extension SGButton {
    
    convenience init(_ title: String) {
        self.init()
        
        self.initFrame(title)
        self.initAsSuper(title)
        
        self.addTarget(self, action: #selector(sgButtonTouchUpInsideEvent), for: .touchUpInside)
        self.addTarget(self, action: #selector(sgButtonTouchDownEvent), for: UIControl.Event.touchDown)
    }
    
    private func initFrame(_ title: String){
        self.frame.size = CGSize(width: title.getTextFitWidth(), height: title.getTextFitHeight())
    }
    
}

//  MARK: - Text And Image To Show.
extension SGButton {
    
    convenience init(_ title: String, imageName image: String, imageLocation: ImageLocation) {
        self.init()
    }
    
}

// MARK: - Close To Parent View Width To Show.
extension SGButton {
    
    convenience init(_ title: String, backgroundColor: UIColor) {
        self.init()
        
        self.initAsSuper(title)
        
        self.setTitleColor(UIColor.black, for: .normal)
        self.frame.size = CGSize(width: UIScreen.main.bounds.width - 30, height: title.getTextFitHeight() + 8)
        self.layer.cornerRadius = 5
        self.backgroundColor = backgroundColor
        self.defaultBackgroundColor = backgroundColor
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.18
        self.layer.shadowRadius = 4.5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
        self.addTarget(self, action: #selector(sgButtonTouchUpInsideEvent), for: .touchUpInside)
        self.addTarget(self, action: #selector(sgButtonTouchDownEvent), for: UIControl.Event.touchDown)
    }
    
}
