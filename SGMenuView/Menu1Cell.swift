//
//  Menu1Cell.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/6/23.
//

import UIKit

open class Menu1Cell: UICollectionViewCell {
    
    public lazy var image: UIImageView = self.createImageView()
    public lazy var label: UILabel = self.createLabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        _initView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.382) {
            self.backgroundColor = .gray.withAlphaComponent(0.382)
        } completion: { (true) in

        }
        
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.282) {
            self.backgroundColor = .clear
        } completion: { (true) in

        }
    }

}

extension Menu1Cell{
    
    fileprivate func _initView(){
        self.contentView.addSubview(image)
        self.contentView.addSubview(label)
    }
    
    fileprivate func createImageView() -> UIImageView{
        let padding: CGFloat = 13
        let image = UIImageView(frame: CGRect(x: padding / 2,
                                              y: padding,
                                              width: cWidth() - padding,
                                              height: cWidth() - padding))
        return image
    }
    
    fileprivate func createLabel() -> UILabel{
        let label = UILabel(frame: CGRect(x: 0,
                                          y: image.frame.maxY + 2,
                                          width: cWidth(),
                                          height: 25))
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }
    
    fileprivate func cWidth() -> CGFloat{
        return self.frame.width
    }
    fileprivate func cHeight() -> CGFloat{
        return self.frame.height
    }
}
