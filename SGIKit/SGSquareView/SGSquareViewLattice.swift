//
//  SGSquareViewLattice.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/3/9.
//

import UIKit

class SGSquareViewLattice: UIView {
    
    lazy var label: UILabel = self.createLabel()
    
    lazy var image: UIImageView = self.createImageView()
    
    private var _size: CGSize!
    /// CGSize for SGSquareViewLattice.
    public var size: CGSize?{
        set{
            _size = newValue
            self.frame.size = _size
        }
        get{
            return _size
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Convenience Init.
extension SGSquareViewLattice{
    
    convenience init(title: String, imageName: String) {
        self.init()
        
        self.addSubview(label)
        self.addSubview(image)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.28
        self.layer.shadowRadius = 4.5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.backgroundColor = .systemPink
    }
    
    fileprivate func createLabel() -> UILabel{
        let label = UILabel()
        return label
    }
    
    fileprivate func createImageView() -> UIImageView{
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 80, height: 80)
        imageView.center = CGPoint(x: 50, y: 50)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}

extension SGSquareViewLattice{
    
}
