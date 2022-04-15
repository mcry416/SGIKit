//
//  SGString.swift
//  NewNavigationBar
//
//  Created by MengQingyu iMac on 2022/2/10.
//

import UIKit

class ConsLabel: UILabel{
    static let sharedInstance = ConsLabel()
}

extension String{
    
    public func getTextWidth() -> CGFloat{
        let label = ConsLabel.sharedInstance
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }

    public func getTextFitWidth() -> CGFloat{
        let label = ConsLabel.sharedInstance
        label.text = self
        label.sizeToFit()
        return (label.frame.width + 16)
    }
    
    public func getTextHeight() -> CGFloat{
        let label = ConsLabel.sharedInstance
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }

    public func getTextFitHeight(font: UIFont? = .systemFont(ofSize: 16)) -> CGFloat{
        let label = ConsLabel.sharedInstance
        label.font = font
        label.text = self
        label.sizeToFit()
        return (label.frame.height + 6)
    }

}

extension String {

    func textAutoHeight(width:CGFloat, font:UIFont) ->CGFloat{

        let string = self as NSString

        let origin = NSStringDrawingOptions.usesLineFragmentOrigin

        let lead = NSStringDrawingOptions.usesFontLeading

        let ssss = NSStringDrawingOptions.usesDeviceMetrics

        let rect = string.boundingRect(with:CGSize(width: width, height:0), options: [origin,lead,ssss], attributes: [NSAttributedString.Key.font:font], context:nil)

        return rect.height

    }

    func textAutoWidth(height:CGFloat, font:UIFont) ->CGFloat{

        let string = self as NSString

        let origin = NSStringDrawingOptions.usesLineFragmentOrigin

        let lead = NSStringDrawingOptions.usesFontLeading

        let rect = string.boundingRect(with:CGSize(width:0, height: height), options: [origin,lead], attributes: [NSAttributedString.Key.font:font], context:nil)

        return rect.width

    }

}

extension String{
    
    func cut(end: Int) -> String{
        let fontText = Array(self)
        guard fontText.count >= end else { return "" }
        
        var temp: String = ""

        for i in 0..<end{
            temp.append(fontText[i])
        }
        
        return temp
    }
    
}
