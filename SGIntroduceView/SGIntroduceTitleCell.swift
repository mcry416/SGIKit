//
//  SGIntroduceTitleCell.swift
//  LabelTEST
//
//  Created by MengQingyu iMac on 2023/3/2.
//

import UIKit

open class SGIntroduceTitleCell: UICollectionViewCell {
    
    private lazy var largeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var smallTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(largeTitle)
        self.contentView.addSubview(smallTitle)
        
        largeTitle.frame = CGRect(x: 20, y: 0, width: self.frame.width - 40, height: 40)
        smallTitle.frame = CGRect(x: 20, y: self.largeTitle.frame.maxY, width: self.frame.width - 40, height: 90)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCell(_ model: SGIntroduceTitleModel){
        self.largeTitle.text = model.largeText
        self.smallTitle.text = model.smallText
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.smallTitle.alpha = 1
        UIView.animate(withDuration: 0.2) {
            self.smallTitle.alpha = 0
        } completion: { (true) in
            self.smallTitle.alpha = 1
            self.smallTitle.font = .systemFont(ofSize: 12)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.smallTitle.alpha = 1
        UIView.animate(withDuration: 0.2) {
            self.smallTitle.alpha = 0
        } completion: { (true) in
            self.smallTitle.alpha = 1
            self.smallTitle.font = .systemFont(ofSize: 14)
        }
    }
    
}
