//
//  1.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/9/24.
//

import UIKit

extension UILabel {
    
    @discardableResult
    public func setText(_ text: String?) -> Self {
        if let text = text {
            self.text = text
        }
        return self
    }
    
    @discardableResult
    public func setFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    public func setTextColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    @discardableResult
    public func setTextAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult
    public func setAttr(_ attr: NSAttributedString?) -> Self {
        if let attr = attr {
            self.attributedText = attr
        }
        return self
    }
    
}

