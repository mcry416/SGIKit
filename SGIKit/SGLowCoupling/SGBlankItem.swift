//
//  SGBlankItem.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/6/13.
//

import UIKit

class SGBlankItem: SGItem {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
