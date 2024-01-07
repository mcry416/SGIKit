//
//  2.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/9/24.
//

import UIKit

extension UIView {
    
    @discardableResult
    public func setBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func setFrame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    @discardableResult
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func setMaskToBounds(_ isMaskToBounds: Bool) -> Self {
        self.layer.masksToBounds = isMaskToBounds
        return self
    }
    
    @discardableResult
    public func setUserInteraction(_ isEnable: Bool) -> Self {
        self.isUserInteractionEnabled = isEnable
        return self
    }
    
}

