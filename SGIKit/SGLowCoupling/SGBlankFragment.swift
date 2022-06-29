//
//  SGBlankFragment.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/6/13.
//

import UIKit

/// Provide a blank fragment for user to use. It's just a whilte SGItem in here.
class SGBlankFragment: SGFragment, SGFragmentDelegate{

    override init() {
        super.init()
        
        self.animatedInterval = 0
        
    }
    
    /**
     Provide parameter of height to initlized the SGBlankItem.
     - Parameter height: Fragment height, no default.
     */
    convenience init(height: CGFloat) {
        self.init()
        
        let blankItem = SGBlankItem()
        blankItem.size = CGSize(width: kSCREEN_WIDTH, height: height)
        
        items.append(blankItem)
        
        self.delegate = self
    }
    
    func numberOfItemForFragment(_ fragment: SGFragment) -> Int {
        return items.count
    }
    
    func itemAtIndex(_ index: Int, fragment: SGFragment) -> SGItem {
        return items[index]
    }
    
}

