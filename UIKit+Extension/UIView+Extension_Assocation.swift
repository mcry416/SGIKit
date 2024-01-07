//
//  UIView+Extension.swift
//  ListView
//
//  Created by Eldest's MacBook on 2022/9/4.
//

import UIKit

extension UIView{
    
    public typealias ClikBlockType = ()->Void
    
    private struct AssociatedKeys{
        static var clickKey = "CLICK_KEY"
        static var longClickKey = "LONG_CLICK_KEY"
    }
    
    @objc dynamic var tapAction: (() -> Void)?{
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.clickKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let action = objc_getAssociatedObject(self, &AssociatedKeys.clickKey) as? (() -> Void){
                return action
            }
            return nil
        }
    }
    
    public func setOnClickListener(_ tapAction: @escaping ClikBlockType) {
        self.tapAction = tapAction
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSelector))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapSelector(){
        if let tapAction = tapAction {
            tapAction()
        }
    }
    
    func setOnLongClickListener(){
        
    }
    
}

extension UIView {
    
    public func sg_getSnapshot() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.frame.width, height: self.frame.height))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.frame.width, height: self.frame.height),
                                               false,
                                               UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        return image
    }
    
}
