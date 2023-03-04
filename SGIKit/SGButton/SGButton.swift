//
//  SGButton.swift
//  SGIKit
//
//  Created by MCRY416 iMac on 2021/12/19.
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
    
    /// Init source for SGButton of three convience init method.
    private var initSource: InitSource!
    
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
    
    // MARK: - Override Method.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    
        switch initSource {
        case .Text:
            UIView.animate(withDuration: 0.3) {
                self.titleLabel?.textColor = .systemGray
            }
        case .TextImage:
            return
        case .ParentView:
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
                let oldColorR = (self.backgroundColor?.cgColor)?.components![0] ?? 0
                let oldColorG = (self.backgroundColor?.cgColor)?.components![1] ?? 0
                let oldColorB = (self.backgroundColor?.cgColor)?.components![2] ?? 0
                
                // For R,G,B values increase 0.1 to itself that look likes high lighted.
                let newColor = UIColor(red: oldColorR + 0.1, green: oldColorG + 0.1, blue: oldColorB + 0.1, alpha: 1)
                self.backgroundColor = newColor
            }
        case .none:
            return
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch initSource {
        case .Text:
            UIView.animate(withDuration: 0.3) {
                self.titleLabel?.textColor = .systemBlue
            }
            self.sgButtonTouchUpInsideEvent()
        case .TextImage:
            return
        case .ParentView:
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
                self.backgroundColor = self.defaultBackgroundColor
            }
            
            // When execute this override method, which equals to execute UIButtonEvent.touchUpInside.
            self.sgButtonTouchUpInsideEvent()
        case .none:
            return
        }
    }
    
    // MARK: - Init Method.
    private func initAsSuper(_ title: String, initSource: InitSource){
        switch initSource {
        case .Text:
            self.setTitle(title, for: UIControl.State.normal)
            self.setTitleColor(.systemBlue, for: UIControl.State.normal)
  //          self.setTitleColor(.systemGray, for: UIControl.State.highlighted)
  //          self.titleLabel?.textColor = .systemBlue
        case .TextImage:
            self.setTitle(title, for: UIControl.State.normal)
            self.setTitleColor(.systemBlue, for: UIControl.State.normal)
            self.setTitleColor(.systemGray, for: UIControl.State.highlighted)
        case .ParentView:
            self.setTitle(title, for: UIControl.State.normal)
            self.setTitleColor(.black, for: UIControl.State.normal)
        }
    }
    
    private func setInitSource(_ initSource: InitSource){
        self.initSource = initSource
    }
    
    // MARK: - SGButton Event.
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
    
    /**
     Text Show Only.
     - Parameter title : SGButton title.
     */
    convenience init(_ title: String) {
        self.init()
        
        self.setInitSource(InitSource.Text)
        self.initFrame(title)
        self.initAsSuper(title, initSource: .Text)
        
//        self.addTarget(self, action: #selector(sgButtonTouchUpInsideEvent), for: .touchUpInside)
//        self.addTarget(self, action: #selector(sgButtonTouchDownEvent), for: UIControl.Event.touchDown)
    }
    
    private func initFrame(_ title: String){
//        self.frame.size = CGSize(width: title.getTextFitWidth(), height: title.getTextFitHeight())
    }
    
}

//  MARK: - Text And Image To Show.
extension SGButton {
    
    /**
     Text And Image To Show.
     - Parameter title : SGButton title.
     - Parameter imageName : SGButton inside image name.
     - Parameter imageLocation : Inside image position near the text.
     */
    convenience init(_ title: String, imageName image: String, imageLocation: ImageLocation) {
        self.init()
        
        self.setInitSource(InitSource.TextImage)
        self.initAsSuper(title, initSource: .TextImage)
        self.imageView?.image = UIImage(named: image)
    }
    
}

// MARK: - Close To Parent View Width To Show.
extension SGButton {
    
    /**
     Close To Parent View Width To Show.
     - Parameter title : Button title.
     - Parameter backgroundColor: SGButton background color.
     */
    convenience init(_ title: String, backgroundColor: UIColor) {
        self.init()
        
        self.setInitSource(InitSource.ParentView)
        self.initAsSuper(title, initSource: .ParentView)
        
        setBasicAttributes(title)
        
        setShadow()
    }
    
    private func setShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.18
        self.layer.shadowRadius = 4.5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    private func setBasicAttributes(_ title: String){
        self.setTitleColor(UIColor.black, for: .normal)
//        self.frame.size = CGSize(width: UIScreen.main.bounds.width - 30, height: title.getTextFitHeight() + 8)
        self.layer.cornerRadius = 5
        self.backgroundColor = backgroundColor
        self.defaultBackgroundColor = backgroundColor
    }
    
}
