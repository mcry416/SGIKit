//
//  Menu1Model.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/6/23.
//

import Foundation

class Menu1Model: NSObject{
    
    var title: String = ""
    
    var imageName: String = ""
    
    init(_ title: String, _ imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
