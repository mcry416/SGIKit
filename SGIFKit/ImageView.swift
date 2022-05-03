//
//  ImageView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/30.
//

import UIKit

extension UIViewController{
    
    @discardableResult
    func ImageView(name: String,
                   size: CGSize = .zero,
                   bind: Int = 0 ) -> UIImageView{
        assert(name != "", "ImageView must be initlized with an un-nil string.")
        
        let image = UIImage(named: name)
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame.size = (size == .zero) ? image!.size : size
        imageView.frame.size = size
        
        if bind != 0{
            imageView.tag = bind
        }
        
        return imageView
    }
    
}
