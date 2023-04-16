//
//  SGIntroduceImageCell.swift
//  LabelTEST
//
//  Created by MengQingyu iMac on 2023/3/2.
//

import UIKit

class SGIntroduceImageCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 20, y: 10, width: self.frame.width - 40, height: self.frame.height - 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCell(_ model: SGIntroduceImageModel){
        self.imageView.image = UIImage(named: model.imageName)
    }
    
}
