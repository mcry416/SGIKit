//
//  SGListView.swift
//  FifthNavigation
//
//  Created by MengQingyu iMac on 2022/1/20.
//

import UIKit

enum ListViewDirection {
    case horizontal
    case vertical
}

class SGListView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let CGRectZero =  CGRect(x: 0, y: 0, width: 0, height: 0)
    
    /// SGListView inner reusable id. Related to cellClass.
    private var REUSABLE_ID = "SG_LIST_VIEW"
    
    public var layoutItem: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private var _itemSize: CGSize?
    /// Size of cell item for SGListView.
    public var itemSize: CGSize?{
        get{
            return _itemSize
        }
        set{
            _itemSize = newValue
            self.layoutItem.itemSize = _itemSize!
        }
    }
    
    private var _setOnCellClickListener: SetOnCellClickListener?
    /// Click event of cell for UICollectionView.
    public var setOnCellClickListener: SetOnCellClickListener?{
        get{
            return _setOnCellClickListener
        }
        set{
            _setOnCellClickListener = newValue
        }
    }
    
    private var _setCellDataBindingWithIndex: SetCellDataBindingWthIndex?
    /// To bind cell and outside data source(dataList) with index.
    public var setCellDataBidningWithIndex: SetCellDataBindingWthIndex?{
        get{
            return _setCellDataBindingWithIndex
        }
        set{
            _setCellDataBindingWithIndex = newValue
        }
    }
    
    private var _setCellDataBinding: SetCellDataBinding?
    /// To bind cell and data by indexPath.
    public var setCellDataBinding: SetCellDataBinding?{
        get{
            return _setCellDataBinding
        }
        set{
            _setCellDataBinding = newValue
        }
    }

//    private var reusableId: String!
    
    /// SGListView data list, which will set delegate and dataSource to SGListView itself while didiSet, consequentlly it could be initing and defining safely when used.
    public var dataList: Array<Array<Any>>?{
        didSet{
            self.delegate = self
            self.dataSource = self
        }
    }
    
    ///  Generate reusable id when did set. eg. "SG_LIST_VIEW_MyCell_372"
    private var cellClass: AnyClass! {
        didSet{
            REUSABLE_ID = "\(REUSABLE_ID)_\(NSStringFromClass(cellClass))_\(Int(arc4random_uniform(1000)))"
        }
    }
    
    // MARK: Override init and method.
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layoutItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadItems(at indexPaths: [IndexPath]) {
        super.reloadItems(at: indexPaths)
    }
    
    /// Reload accurate position of cell rather than reload all data.
    override func reloadData() {
        super.reloadData()
    }
    
    override func deleteItems(at indexPaths: [IndexPath]) {
        super.deleteItems(at: indexPaths)
    }
    
    override func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        super.moveItem(at: indexPath, to: newIndexPath)
    }
    
    override func insertItems(at indexPaths: [IndexPath]) {
        super.insertItems(at: indexPaths)
    }
    
    // FIXME: - FIX HIGH.
    // MARK: - Init configuration.
    public func initConfig(cellClass: AnyClass, reusableId: String){
//        self.delegate = self
//        self.dataSource = self
 //       self.reusableId = reusableId
        self.register(cellClass, forCellWithReuseIdentifier: reusableId)
    }
    
    private func initDirection(direction: ListViewDirection){
        layoutItem = UICollectionViewFlowLayout()
        if direction == .horizontal {
            layoutItem.scrollDirection = .horizontal
        }
        if direction == .vertical {
            layoutItem.scrollDirection = .vertical
        }
        // Load more configuration...

    }
    
    private func initOrderWithSuper(){
        self.frame = CGRectZero
        self.collectionViewLayout = layoutItem
    }
    
    // MARK: - SGListView init method.
    convenience init(direction: ListViewDirection, cellClass: AnyClass) {
        self.init()
        self.initDirection(direction: direction)
        self.initOrderWithSuper()
        self.initConfig(cellClass: cellClass, reusableId: REUSABLE_ID)
    }
    
}

// MARK: - UICollectionViewDelegate.
extension SGListView{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setOnCellClickListener!(indexPath)
    }
    
}

// MARK: - UICollectionViewDataSource.
extension SGListView{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList![section].count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tempDataList = dataList!

        let cell = dequeueReusableCell(withReuseIdentifier: REUSABLE_ID, for: indexPath)
        
        // Only outside model was availiable, or best.
        if setCellDataBinding != nil {
            setCellDataBinding!(cell, tempDataList[indexPath.section][indexPath.row])
        }

        // Only outside index was availiable.
        if setCellDataBidningWithIndex != nil {
            setCellDataBidningWithIndex!(cell, indexPath.row)
        }
        
        return cell
    }
    
}
