//
//  SGGoodsCell.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/2.
//

import UIKit

open class SGGoodsCell: UICollectionViewCell {
    
    public lazy var imageView: UIImageView = self.createImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Not implement.")
    }
    
}

extension SGGoodsCell{
    
    fileprivate func createImageView() -> UIImageView{
        let imageView = UIImageView()
        return imageView
    }
    
}
