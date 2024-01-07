//
//  SGExcelAdapter.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/10/17.
//

import UIKit

public enum SGExcelType {
    case readOnly
    case readWrite
}

open class SGExcelAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var setExcelCellClickAction: ((_ row: Int, _ column: Int) -> Void)?
    public var setTextFieldWillEditAction: ((_ content: String, _ row: Int, _ column: Int) -> Void)?
    public var setTextFieldDidEditAction: ((_ content: String, _ row: Int, _ column: Int) -> Void)?
        
    private var datas: Array<SGExcelRow>!
    private var id: String!
    private var excelType: SGExcelType = .readOnly
    
    init(_ datas: Array<SGExcelRow>, id: String, excelType: SGExcelType){
        self.datas = datas
        self.id = id
        self.excelType = excelType
    }
    
    public func setDatas(datas: Array<SGExcelRow>){
        self.datas = datas
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.excelType == .readOnly {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.id, for: indexPath) as! SGExcelButtonCell
            let row: SGExcelRow = datas[indexPath.row]
            
            // Use buttonDatas as first choice.
            if row.buttonDatas.count > 0 {
                cell.setSubElements(row.buttonDatas.count)
                var subElementIndex: Int = 0
                for button in row.buttonDatas {
                    cell.setCellButton(at: subElementIndex, button: button)
                    cell.buttonClickClosure = { [weak self] index in
                        guard let `self` = self else { return }
                        self.setExcelCellClickAction?(indexPath.row, index)
                    }
                    subElementIndex = subElementIndex + 1
                }
            } else {
                cell.setSubElements(row.textDatas.count)
                var subElementIndex: Int = 0
                for text in row.textDatas {
                    cell.setCell(at: subElementIndex, text: text)
                    cell.buttonClickClosure = { [weak self] index in
                        guard let `self` = self else { return }
                        self.setExcelCellClickAction?(indexPath.row, index)
                    }
                    subElementIndex = subElementIndex + 1
                }
            }

            cell.setBottomLine()
            
            return cell
        }
        if self.excelType == .readWrite {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.id, for: indexPath) as! SGExcelTextFieldCell
            let row: SGExcelRow = datas[indexPath.row]
            
            cell.setCellElements(row.textFieldDatas.count)
            var subElementIndex: Int = 0
            for textField in row.textFieldDatas {
                cell.setCellTextField(at: subElementIndex, textField: textField)
                cell.setOnTextFieldDidChangeAction = { [weak self] (text, column) in
                    guard let `self` = self else { return }
                    self.setTextFieldDidEditAction?(text, indexPath.row, column)
                }
                subElementIndex = subElementIndex + 1
            }
            cell.setBottomLine()
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}
