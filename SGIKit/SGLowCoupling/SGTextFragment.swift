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
    
    /**
     
     */
    convenience init(fragmentModel model : SGTextFragmentModel) {
        self.init()
        
        let textItem = SGTextItem(text: model.text, centerOffset: 0)
        textItem.label.font = model.textFont
        textItem.label.textColor = model.textColor
        textItem.label.frame = CGRect(x: model.textEdgeInset.right,
                                      y: model.textEdgeInset.top,
                                      w: kSCREEN_WIDTH - model.textEdgeInset.right - model.textEdgeInset.left,
                                      h: model.text.ehi_height(font: model.textFont, maxWidth: kSCREEN_WIDTH - model.textEdgeInset.left - model.textEdgeInset.right))
        textItem.backgroundColor = model.backgroundColor
        textItem.size = CGSize(width: kSCREEN_WIDTH,
                               height: model.text.ehi_height(font: model.textFont, maxWidth: kSCREEN_WIDTH - model.textEdgeInset.left - model.textEdgeInset.right) + model.textEdgeInset.top + model.textEdgeInset.bottom)
        
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
