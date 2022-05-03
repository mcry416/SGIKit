//
//  Button.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/30.
//

import UIKit

var SET_ASSOCIATE_KEY_BUTTON = "Button"

extension UIViewController{
    
    @discardableResult
    func Button(text: String,
                font: UIFont = .systemFont(ofSize: 14, weight: .medium),
                bind: Int  = 0,
                listener: (() -> Void)?) -> IFButton{
        let button = IFButton(type: .custom)
        var rect: CGRect = .zero
        rect = CGRect(x: 0,
                      y: 0,
                      width: text.getTextWidth() + 30,
                      height: text.getTextHeight())
        button.frame = rect
        button.titleLabel?.font = font
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.setOnClickListener = { [weak self] in
            listener!()
            Log.debug(" set on")
        }
        
        
//        var SET_ASSOCIATE_KEY_BUTTON = "Button"
//        objc_setAssociatedObject(self, &SET_ASSOCIATE_KEY_BUTTON, listener, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
//        button.addTarget(self, action: #selector(sgifButtonEvent), for: .touchUpInside)
        
        return button
    }
    
//    @objc fileprivate func sgifButtonEvent(){
//        var SET_ASSOCIATE_KEY_BUTTON = "Button"
//        let listener = objc_getAssociatedObject(self, &SET_ASSOCIATE_KEY_BUTTON) as! () -> Void
//        listener()
//    }
    
}

class IFButton: UIButton{
    
    typealias SetOnButtonClickListener = (() -> Void)
    
    var setOnClickListener: SetOnButtonClickListener?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setOnClickListener!()
    }
}
