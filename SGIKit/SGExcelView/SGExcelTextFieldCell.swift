//
//  SGExcelTextFieldCell.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/10/17.
//

import UIKit

class SGExcelTextFieldCell: UICollectionViewCell {
    
    private var subTextFields: Array<UITextField> = { Array<UITextField>() }()
    
    public var setOnTextFieldDidChangeAction: ((_ text: String, _ column: Int) -> Void)?
    
    private func createTextField() -> UITextField{
        let textFiled = UITextField()
        
        return textFiled
    }
    private func createBottomLine() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5)
        view.backgroundColor = .gray.withAlphaComponent(0.35)
        return view
    }
}

extension SGExcelTextFieldCell {
    
    public func setCellElements(_ count: Int){
        let w: CGFloat = self.frame.width / CGFloat(count)
        for index in 0..<count {
            let textField: UITextField = self.createTextField()
            textField.tag = index
            textField.addTarget(self, action: #selector(setOnTextFieldDidEndEvent(_:)), for: .editingChanged)
            textField.frame = CGRect(x: CGFloat(index) * w, y: 0, width: w, height: self.frame.height)
            
            self.contentView.addSubview(textField)
            self.subTextFields.append(textField)
        }
    }
    
    public func setCellTextField(at index: Int, textField: UITextField){
        let temp: UITextField = self.subTextFields[index]
        temp.text = textField.text
        temp.placeholder = textField.placeholder
        temp.leftView = textField.leftView
        temp.rightView = textField.rightView
        temp.font = textField.font
        temp.textColor = textField.textColor
        temp.backgroundColor = textField.backgroundColor
        temp.tintColor = textField.tintColor
        temp.textAlignment = textField.textAlignment
    }
    
    public func setBottomLine(){
        self.contentView.addSubview(createBottomLine())
    }
    
    @objc private func setOnTextFieldDidEndEvent(_ textField: UITextField){
        self.setOnTextFieldDidChangeAction?((textField.text ?? ""), textField.tag)
    }
    
}
