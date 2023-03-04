//
//  SGExcelRow.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/10/17.
//

import UIKit

@objcMembers class SGExcelRow: NSObject {

    public lazy var textDatas: Array<String> = { Array<String>() }()
    public lazy var buttonDatas: Array<UIButton> = { Array<UIButton>() }()
    public lazy var textFieldDatas: Array<UITextField> = { Array<UITextField>() }()
    
    public func addBody(_ texts: String...){
        texts.forEach { str in
            textDatas.append(str)
        }
    }
    
    public func addBody(_ buttons: UIButton...){
        buttons.forEach { button in
            buttonDatas.append(button)
        }
    }
    
    public func addBody(_ textFields: UITextField...){
        textFields.forEach { textField in
            textFieldDatas.append(textField)
        }
    }
    
    public func clearAll(){
        textDatas.removeAll()
        buttonDatas.removeAll()
        textFieldDatas.removeAll()
    }
}
