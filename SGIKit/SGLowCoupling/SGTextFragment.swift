//
//  SGTextFragment.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/6/13.
//

import UIKit

/// Provide a text only fragment for user to use.
class SGTextFragment: SGFragment, SGFragmentDelegate{

    override init() {
        super.init()
        
        self.animatedInterval = 0
        
    }
    
    convenience init(text: String) {
        self.init()
        
        let textItem = SGTextItem(text: text, centerOffset: 0)
        textItem.size = CGSize(width: kSCREEN_WIDTH, height: 50)
        
        items.append(textItem)
        
        self.delegate = self
    }
    
    func numberOfItemForFragment(_ fragment: SGFragment) -> Int {
        return items.count
    }
    
    func itemAtIndex(_ index: Int, fragment: SGFragment) -> SGItem {
        return items[index]
    }
    
}
