//
//  SGParaImage.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/24.
//

import UIKit
import SwiftUI

extension UIImage{
    
    enum ColorsDirection {
        case horizontal
        case vertical
    }
    
    /**
     Initlize an image instance with colors and basic attributes.
     - Parameter colors: Gradient colors.
     - Parameter size: Image size.
     - Parameter colorsDirection: Gradient colors direction in the image.
     - Returns: Colorful image instance.
     */
    convenience init(colors: [UIColor],
                     size: CGSize = CGSize(width: 10, height: 10),
                     colorsDirection: ColorsDirection = .horizontal) {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = colors.map { (color: UIColor) -> AnyObject? in
            return color.cgColor as AnyObject?
        } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        
        var endPoint: CGPoint = .zero
        if colorsDirection == .horizontal {
            endPoint = CGPoint(x: size.width, y: 0)
        }
        if colorsDirection == .vertical {
            endPoint = CGPoint(x: 0, y: size.height)
        }
        
        context!.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        
        UIGraphicsEndImageContext()
    }
    
    enum WatermarkLocation {
        case Center
        case BototomCenter
        case BottomLeft
        case BottomRight
    }

}

extension UIImage{
    
    /**
     Initlize a colorful image instance that draw a text with colors and basic attributes and text content.
     - Note: Text content has been defiend a concrete style already.
     - Parameter colors: Gradient colors.
     - Parameter colorsDirection: Gradient colors direction in the image.
     - Parameter text: Draw text content.
     - Returns: Colorful image instance with text content.
     */
    convenience init(colors: [UIColor],
                     colorsDirection: ColorsDirection = .horizontal,
                     text: String) {
        let size: CGSize = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = colors.map { (color: UIColor) -> AnyObject? in
            return color.cgColor as AnyObject?
        } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        
        // Judge the gradient color direction.
        var endPoint: CGPoint = .zero
        if colorsDirection == .horizontal {
            endPoint = CGPoint(x: size.width, y: 0)
        }
        if colorsDirection == .vertical {
            endPoint = CGPoint(x: 0, y: size.height)
        }
        
        context!.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        // Create image instance by cgImage.
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        
        // Set text attributes like color and font.
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)]
        let textSize = NSString(string: text).size(withAttributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        let imageSize = self.size

        // Reset text frame and let it to be center position.
        textFrame.origin = CGPoint(x: (imageSize.width / 2) - (textSize.width / 2),
                                   y: imageSize.height - (textSize.height * 4))
        textFrame.origin = CGPoint(x: 50, y: 50)
        
        
        
        NSString(string: text).draw(in: textFrame, withAttributes: textAttributes)
        
        UIGraphicsEndImageContext()
    }
    
}
