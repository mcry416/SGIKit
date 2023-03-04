//
//  SGExcelView.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/10/17.
//

import UIKit

class SGExcelView: UIView {
    
    // MARK: - Public Variables.
    public var isShowSeprateLine: Bool = true
    
    public var isFixedColumScroll: Bool = true
    
    public var excelType: SGExcelType = .readOnly
    
    public var rowHeight: CGFloat = 0
    
    override var frame: CGRect{
        didSet{
            self.collectionView.frame = CGRect(origin: .zero, size: frame.size)
        }
    }
    
    override var backgroundColor: UIColor?{
        didSet{
            self.collectionView.backgroundColor = backgroundColor ?? .clear
        }
    }
    
    // MARK: - Private Variables.
    private let EXCEL_CELL_ID: String = "E_C_ID"
    private var datas: Array<SGExcelRow>!
    private var excelAdapter: SGExcelAdapter!
    
    private lazy var collectionView: UICollectionView = self.createCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implement.")
    }

}

// MARK: - Event
extension SGExcelView{
    
    @discardableResult
    public func addRow(_ row: SGExcelRow) -> Self{
        if datas == nil {
            datas = Array<SGExcelRow>()
        }
        
        datas.append(row)
        
        return self
    }
    
    @discardableResult
    public func insertRow(at index: Int, row: SGExcelRow) -> Self{
        assert(datas.count > 0, "Delete operation must be relyed on the datas count bigger than 0.")
        datas.insert(row, at: index)
        excelAdapter.setDatas(datas: datas)
        collectionView.reloadData()
        
        return self
    }
    
    @discardableResult
    public func deleteRow(at index: Int) -> Self{
        assert(datas.count > 0, "Delete operation must be relyed on the datas count bigger than 0.")
        datas.remove(at: index)
        excelAdapter.setDatas(datas: datas)
        //collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        collectionView.reloadData()
        
        return self
    }
    
    @discardableResult
    public func deleteRowAll() -> Self{
        datas.removeAll()
        collectionView.reloadData()
        
        return self
    }
    
    @discardableResult
    public func updateRow(at index: Int, row: SGExcelRow) -> Self{
        datas.remove(at: index)
        datas.insert(row, at: index)
        collectionView.reloadData()
        
        return self
    }
    
    @discardableResult
    public func update() -> Self{
        collectionView.reloadData()
        
        return self
    }
    
    @discardableResult
    public func builder() -> Self{
        excelAdapter = SGExcelAdapter(datas, id: EXCEL_CELL_ID, excelType: self.excelType)
        if excelType == .readOnly {
            collectionView.register(SGExcelButtonCell.self, forCellWithReuseIdentifier: EXCEL_CELL_ID)
        } else if excelType == .readWrite{
            collectionView.register(SGExcelTextFieldCell.self, forCellWithReuseIdentifier: EXCEL_CELL_ID)
        }
        collectionView.dataSource = excelAdapter
        collectionView.delegate = excelAdapter
        self.layer.masksToBounds = true
        self.addSubview(collectionView)
        
        return self
    }
    
    @discardableResult
    public func setOnExcelWillEditListener(_ listener: ((_ content: String,  _ row: Int, _ column: Int) -> Void)?) -> Self{
//        excelAdapter.setTextFieldWillEditAction = { (content) in
//            listener?(content)
//        }
        
        return self
    }
    
    @discardableResult
    public func setOnExcelDidEditListener(_ listener: ((_ content: String,  _ row: Int, _ column: Int) -> Void)?) -> Self{
        excelAdapter.setTextFieldDidEditAction = { (content, row, column) in
            listener?(content, row, column)
        }
        
        return self
    }
    
    @discardableResult
    public func setOnExcelCellClickListener(_ listener: ((_ row: Int, _ column: Int) -> Void)?) -> Self{
        excelAdapter.setExcelCellClickAction = { (row, column) in
            listener?(row, column)
        }
        
        return self
    }

}

// MARK: - View
extension SGExcelView{
    
    private func initView(){
        self.addSubview(collectionView)
    }
    
    private func createCollectionView() -> UICollectionView{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.frame.width, height: 30)
        layout.minimumLineSpacing = CGFloat.leastNormalMagnitude
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.alwaysBounceVertical = true
//        view.alwaysBounceHorizontal = true
        
        return view
    }
    
}

extension SGExcelView{
    
}

