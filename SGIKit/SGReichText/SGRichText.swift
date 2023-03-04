//
//  SGRichText.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/3/2.
//

import UIKit

class SGRichText: NSObject {
    
    private var describeModel: [NSAttributedString.Key: Any] = { [NSAttributedString.Key: Any]() }()
    
    public var string: String!
    
    init(_ string: String) {
        self.string = string
    }
    
    public func setBackgroundColor(_ color: UIColor) -> Self{
        self.describeModel[NSAttributedString.Key.backgroundColor] = color
        return self
    }
    
    public func setForegroundColorColor(_ color: UIColor) -> Self{
        self.describeModel[NSAttributedString.Key.foregroundColor] = color
        return self
    }
    
    public func setFont(_ font: UIFont) -> Self{
        self.describeModel[NSAttributedString.Key.font] = font
        return self
    }
    
    public func setShadow(shadowColor: UIColor, shadowRadius: CGFloat) -> Self{
        let shadow: NSShadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowRadius
        self.describeModel[NSAttributedString.Key.shadow] = shadow
        return self
    }
    
    public func builder() -> NSAttributedString{
        NSAttributedString(string: self.string, attributes: self.describeModel)
    }
    
}
