//
//  SGImageThumbnail.swift
//  LightCamera
//
//  Created by Eldest's MacBook on 2022/4/6.
//

import UIKit

extension UIImage{
    
    
    func thumbnail() -> UIImage{
        let image = self
        
        // Find a minimum edge of image size.
        let imageSize = image.size
        let thumbnailEdge: CGFloat = imageSize.width > imageSize.height ? imageSize.width : imageSize.height
        // Draw a concrete size image.
        UIGraphicsBeginImageContext(CGSize(width: thumbnailEdge, height: thumbnailEdge))
        image.draw(in: CGRect(x: 0, y: 0, width: thumbnailEdge, height: thumbnailEdge))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Compress image into Data type.
        let maxLength: Int = 64
        var compress: CGFloat = 0.9
        var data = newImage!.jpegData(compressionQuality: compress)
        // Iterator.
        while data!.count > maxLength && compress > 0.01 {
            compress -= 0.02
            data = newImage!.jpegData(compressionQuality: compress)
        }
        
        // Transfer Data into UIImage type.
        let tempImage: UIImage = UIImage(data: data!)!
        
        return tempImage
    }
    
    func thumbWithNative() -> UIImage{
        let data: Data = self.jpegData(compressionQuality: 0.05)!
        return UIImage(data: data, scale: 0.2)!
    }
    
}
