//
//  BindClass.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/1.
//

import UIKit

class BindClass: NSObject{
    
    var bind: String = ""
    
    var tag: Int = 0
    
    init(bind: String, tag: Int) {
        self.bind = bind
        self.tag = tag
    }
}
