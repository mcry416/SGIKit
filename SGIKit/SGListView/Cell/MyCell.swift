//
//  MyCell.swift
//  FouthNavigationBar
//
//  Created by MengQingyu iMac on 2022/1/21.
//

import UIKit

class MyCell: UICollectionViewCell {
    
    public var label: UILabel!
    public var label2: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        self.layer.cornerRadius = 10

        label = UILabel(frame: CGRect(x: 10, y: (self.contentView.frame.height / 2) - 15, width: 130, height: 30))
        label.textAlignment = .center
        self.addSubview(label)
        
        label2 = UILabel(frame: CGRect(x: self.contentView.frame.width - 130, y: (self.contentView.frame.height / 2) - 15, width: 70, height: 30))
        label2.textAlignment = .center
        self.addSubview(label2)
    }

}
