//
//  Menu1Model.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/6/23.
//

import Foundation

open class Menu1Model: NSObject{
    
    public var title: String = ""
    
    public var imageName: String = ""
    
    public init(_ title: String, _ imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
