//
//  SGString.swift
//  NewNavigationBar
//
//  Created by MengQingyu iMac on 2022/2/10.
//

import UIKit

class ConstructorLabel: UILabel{
    static let sharedInstance = ConstructorUILabel()
}

extension String{
    
    public func getTextWidth() -> CGFloat{
        let label = ConstructorUILabel.sharedInstance
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }

    public func getTextFitWidth() -> CGFloat{
        let label = ConstructorUILabel.sharedInstance
        label.text = self
        label.sizeToFit()
        return (label.frame.width + 16)
    }
    
    public func getTextHeight() -> CGFloat{
        let label = ConstructorUILabel.sharedInstance
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }

    public func getTextFitHeight() -> CGFloat{
        let label = ConstructorUILabel.sharedInstance
        label.text = self
        label.sizeToFit()
        return (label.frame.height + 6)
    }

}
