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

class SGButton: UIButton{
    
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
    }
    
}
