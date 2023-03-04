//
//  UIImage+Extension.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/3/3.
//

import Foundation
import UIKit

extension UIImage {
    
    func thumbWithNative() -> UIImage{
        let data: Data = self.jpegData(compressionQuality: 0.01)!
        return UIImage(data: data, scale: 0.2)!
    }
    
    func thumbWithNativePercent(percent: Float) -> UIImage{
        let data: Data = self.jpegData(compressionQuality: CGFloat(percent))!
        return UIImage(data: data, scale: 1)!
    }
    
}

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

}

// MARK: - Watermark
extension UIImage{
    
    enum WatermarkLocation {
        case Center
        case BototomCenter
        case BottomLeft
        case BottomRight
    }
    
    /**
     Return a watermark image by UIGraphycsEndImage.
     - Text only need to pass.
     - Parameter text: Content.
     - Parameter location: Content location in image, defalut center.
     - Parameter textColor: Content color, defalut white.
     - Parameter textFont: Content font, defalut medium and size of 100.
     - Returns: UIImage instance of writting content.
     */
    func watermark(_ text: String,
                   location: WatermarkLocation = .BototomCenter,
                   textColor: UIColor = .white,
                   textFont: UIFont = .systemFont(ofSize: 100, weight: UIFont.Weight.medium)) -> UIImage{
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:textColor, NSAttributedString.Key.font:textFont]
        let textSize = NSString(string: text).size(withAttributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        let imageSize = self.size
        switch location {
        case .Center:
            textFrame.origin = CGPoint(x: (imageSize.width / 2) - (textSize.width / 2),
                                       y: (imageSize.height / 2) - (textSize.height / 2))
        case .BototomCenter:
            textFrame.origin = CGPoint(x: (imageSize.width / 2) - (textSize.width / 2),
                                       y: imageSize.height - (textSize.height * 4))
        case .BottomLeft:
            textFrame.origin = CGPoint(x: imageSize.width / 10,
                                       y: imageSize.height - (textSize.height * 2))
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - (textSize.width * 10),
                                       y: imageSize.height - (textSize.height * 4))
        }
        
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: text).draw(in: textFrame, withAttributes: textAttributes)

        let watermarkImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return watermarkImage!
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
