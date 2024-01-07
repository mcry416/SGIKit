//
//  ImageMerge.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/20.
//

import UIKit

/// Merge image util.
open class ImageMerge{
    
    /**
     Merge two images into one image.
     - Note: Merge means avoiding same aera was influenced but changing different area.
     - Parameter root: An image at bottom of the merge layer.
     - Parameter font: An image at top of the merge layer.
     - Parameter completionHandler: When the process of the merge has been finished, callback the merged image.
     - Returns: Merged image.
     */
    public static func merge(_ root: UIImage, after font: UIImage, completionHandler: @escaping (_ resultImage: UIImage) -> Void){
        DispatchQueue(label: "com.sg.sgimage.merge").async {
            
            var rootCIImage = CIImage(image: root)!
            var fontCIImage = CIImage(image: font)!
            
            // Change itself alpha channel.
            rootCIImage = getAlphaChannel(rootCIImage)
            fontCIImage = getAlphaChannel(fontCIImage)
            
            // Use CIFilter to set which CIImage instace was located in bottom or top.
            let sourceOverCompostingFilter = CIFilter(name: "CISourceOverCompositing")
            sourceOverCompostingFilter?.setValue(rootCIImage, forKey: kCIInputBackgroundImageKey)
            sourceOverCompostingFilter?.setValue(fontCIImage, forKey: kCIInputImageKey)
            
            let image = UIImage(ciImage: (sourceOverCompostingFilter?.outputImage)!)

            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
    
    // Accoring to concrete CIImage instance to return a object that has alpha channel changes.
    private static func getAlphaChannel(_ source: CIImage) -> CIImage{
        guard let overlayFilter: CIFilter = CIFilter(name: "CIColorMatrix") else { fatalError() }
        let overlayRgba: [CGFloat] = [0, 0, 0, 0.5]
        let alphaVector: CIVector = CIVector(values: overlayRgba, count: 4)
        overlayFilter.setValue(source, forKey: kCIInputImageKey)
        overlayFilter.setValue(alphaVector, forKey: "inputAVector")
        
        return overlayFilter.outputImage!
    }
    
}
