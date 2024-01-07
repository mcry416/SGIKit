//
//  3.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/9/24.
//

import UIKit

extension UIImageView {
    
    @discardableResult
    public func setImage(_ imageName: String) -> Self {
        if let img = UIImage(named: imageName) {
            self.image = img
        }
        return self
    }
    
}

