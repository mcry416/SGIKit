//
//  SGExcelRow.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/10/17.
//

import UIKit

@objcMembers open class SGExcelRow: NSObject {

    open lazy var textDatas: Array<String> = { Array<String>() }()
    open lazy var buttonDatas: Array<UIButton> = { Array<UIButton>() }()
    open lazy var textFieldDatas: Array<UITextField> = { Array<UITextField>() }()
    
    open func addBody(_ texts: String...){
        texts.forEach { str in
            textDatas.append(str)
        }
    }
    
    open func addBody(_ buttons: UIButton...){
        buttons.forEach { button in
            buttonDatas.append(button)
        }
    }
    
    open func addBody(_ textFields: UITextField...){
        textFields.forEach { textField in
            textFieldDatas.append(textField)
        }
    }
    
    open func clearAll(){
        textDatas.removeAll()
        buttonDatas.removeAll()
        textFieldDatas.removeAll()
    }
}
