//
//  String+Extension.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/3/2.
//

import Foundation
import UIKit

extension String{
    
    /** From start length to cut specific length string */
    public func cut(end: Int) -> String{
        let fontText = Array(self)
        guard fontText.count >= end else { return "" }
        
        var temp: String = ""

        for i in 0..<end{
            temp.append(fontText[i])
        }
        
        return temp
    }
    
}

extension String {

    public func sg_height(maxW: CGFloat, font:UIFont) -> CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics
        let rect = string.boundingRect(with:CGSize(width: maxW, height:0), options: [origin,lead,ssss], attributes: [NSAttributedString.Key.font:font], context:nil)
        return rect.height
    }

    public func sg_width(maxH: CGFloat, font:UIFont) -> CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let rect = string.boundingRect(with:CGSize(width:0, height: maxH), options: [origin,lead], attributes: [NSAttributedString.Key.font:font], context:nil)
        return rect.width
    }

}
