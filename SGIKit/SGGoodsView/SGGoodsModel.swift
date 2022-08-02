//
//  SGGoodsModel.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/2.
//

import UIKit

class SGGoodsModel: NSObject {
    
    var contentMode: UIImageView.ContentMode!
    var imageName: String!
    var urlName: String!
    var image: UIImage!
    
    init(imageName: String, contentMode: UIImageView.ContentMode){
        self.imageName = imageName
        self.contentMode = contentMode
    }
    
    init(urlName: String, contentMode: UIImageView.ContentMode){
        self.urlName = urlName
        self.contentMode = contentMode
    }
    
    init(image: UIImage, contentMode: UIImageView.ContentMode){
        self.image = image
        self.contentMode = contentMode
    }
    
}
