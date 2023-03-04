//
//  SGExcelButtonCell.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/10/17.
//

import UIKit

class SGExcelButtonCell: UICollectionViewCell {
    
    private lazy var subButtons: Array<UIButton> = { Array<UIButton>() }()
    
    public var buttonClickClosure: ((_ column: Int) -> Void)?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("Not implement.")
//    }
    
    private func createButton() -> UIButton{
        let button = UIButton()
        button.setTitleColor(.black.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = kFONT_13
        button.setTitleColor(.gray, for: .highlighted)
        return button
    }
    
    private func createBottomLine() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5)
        view.backgroundColor = .gray.withAlphaComponent(0.35)
        return view
    }
    
}

extension SGExcelButtonCell {
    
    public func setSubElements(_ count: Int){
        let w: CGFloat = self.frame.width / CGFloat(count)
        for index in 0..<count {
            let button: UIButton = self.createButton()
            button.setOnClickListener { [weak self] v in
                guard let `self` = self else { return }
                self.buttonClickClosure?(index)
            }
            
            button.frame = CGRect(x: CGFloat(index) * w, y: 0, width: w, height: self.frame.height)
            
            self.contentView.addSubview(button)
            self.subButtons.append(button)
        }
    }
    
    public func setCell(at index: Int, text: String){
        let button: UIButton = self.subButtons[index]
        button.setTitle(text, for: .normal)
    }
    
    public func setCellButton(at index: Int, button: UIButton){
        let temp: UIButton = self.subButtons[index]
        temp.setTitle(button.title(for: .normal), for: .normal)
        temp.setImage(button.imageView?.image, for: .normal)
        temp.backgroundColor = button.backgroundColor
        temp.titleLabel?.font = button.titleLabel?.font
        temp.setTitleColor(button.titleColor(for: .normal), for: .normal)
        temp.titleEdgeInsets = button.titleEdgeInsets
        temp.imageEdgeInsets = button.imageEdgeInsets
        temp.contentEdgeInsets = button.contentEdgeInsets
    }
    
    public func setBottomLine(){
        self.contentView.addSubview(createBottomLine())
    }
    
}
