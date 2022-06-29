//
//  SGFrgamentDelegate.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/16.
//

import UIKit

@objc protocol SGFragmentDelegate{
    
    func numberOfItemForFragment(_ fragment: SGFragment) -> Int
    
    func itemAtIndex(_ index: Int, fragment: SGFragment) -> SGItem
    
}
