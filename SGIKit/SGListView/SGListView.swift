//
//  SGListView.swift
//  FifthNavigation
//
//  Created by MengQingyu iMac on 2022/1/20.
//

import UIKit

/**
 SGListView, designed with trailing closure function features to easy use, and it's also a effictive widget to update.(use diff to operation.)
 */
class SGListView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    enum DataListOperationType {
        case none
        case insert
        case delete
        case update
        case move
        case mixup
    }
    
    enum ListViewDirection {
        case horizontal
        case vertical
    }
    
    /// SGListView inner reusable id. Related to cellClass.
    private var REUSABLE_ID = "SLV"
    
    /// Flow layout item.
    private var layoutItem: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
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
    
    /// When the cell is going to display event.
    private var setOnCellWillDisplayClosure: SetOnCellWillDisplayClosure?
    
    /// Click event of cell for UICollectionView.
    private var setOnCellClickClosure:       SetOnCellClickClosure?
    
    /// Declick event of cell for UICollectionView.
    private var setOnCellDeclickClosure:     SetOnCellDeclickClosure?
    
    /// Will click event of cell for UICollectionView.
    private var setOnCellWillClickClosure:   SetOnCellWillClickClosure?
    
    /// The click event has been finished event of cell for UICollectionView.
    private var setOnCellFinishClickClosure: SetOnCellFinishClickClosure?
    
    /// To bind cell and outside data source(dataList) with index.
    private var setOnCellDataBindClosure:    SetOnCellDataBindClosure?
    
    /// SGListView data list, which will set delegate and dataSource to SGListView itself while didiSet, consequentlly it could be initing and defining safely when used.
    public var dataList: Array<NSObject>?{
        didSet{
            if self.isFirstLoadDataList {
                self.delegate = self
                self.dataSource = self
            } else {
     //           self.updateItems(old: oldDataList!, new: dataList!)
            }
            self.isFirstLoadDataList = false
        }
    }
    
    typealias DFAW = DiffAware
    
    private var oldDataList: Array<NSObject>?
    
    private var mChanges: Array<NSObject>?
    
    /// The plain expression of `dataList` changes.
    private var dataListOperationType: DataListOperationType = .none
    
    /// Indicate the `dataList` whether first load for update operation.
    private var isFirstLoadDataList: Bool = true
    
    /// Generate reusable id when did set. eg. `SLV_MYCELL_528`.
    private var cellClass: AnyClass! {
        didSet{
            REUSABLE_ID = "\(REUSABLE_ID)_\(NSStringFromClass(cellClass).uppercased())_\(Int(arc4random_uniform(1000)))"
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
    
    // MARK: - Init configuration.
    private final func initConfig(cellClass: AnyClass, reusableId: String){
        self.register(cellClass, forCellWithReuseIdentifier: reusableId)
        
    }
    
    private final func initDirection(direction: ListViewDirection){
   //     layoutItem = UICollectionViewFlowLayout()
        if direction == .horizontal {
            layoutItem.scrollDirection = .horizontal
        }
        if direction == .vertical {
            layoutItem.scrollDirection = .vertical
        }
        // Load more configuration...
        
        

    }
    
    private final func initBasicView(){
        self.frame = .zero
        self.collectionViewLayout = layoutItem
    }
    
    // MARK: - SGListView init method.
    convenience init(direction: ListViewDirection = .vertical, cellClass: AnyClass) {
        self.init()
        
        REUSABLE_ID = "\(REUSABLE_ID)_\(NSStringFromClass(cellClass).uppercased())_\(Int(arc4random_uniform(1000)))"
        
        self.initDirection(direction: direction)
        self.initBasicView()
        self.initConfig(cellClass: cellClass, reusableId: REUSABLE_ID)
    }
    
}

// MARK: - Dynamic DataSource Operation of Diff.
extension SGListView{
    
    /// Reload accurate position of cell rather than reload all data.
    override func reloadData() {
        super.reloadData()
    }
    
    fileprivate func dynamicOperateListView<T: DiffAware>(old: Array<T>, new: Array<T>) -> DataListOperationType{
        let changes = diff(old: old, new: new)
     //   mChanges = changes
        
        // Only delete.
        if changes[0].delete != nil && changes[0].insert == nil && changes[0].move == nil && changes[0].replace == nil {
            return .delete
        }
        // Only insert.
        if changes[0].delete == nil && changes[0].insert != nil && changes[0].move == nil && changes[0].replace == nil {
            return .insert
        }
        // Only move.
        if changes[0].delete == nil && changes[0].insert == nil && changes[0].move != nil && changes[0].replace == nil {
            return .move
        }
        // Only replace.
        if changes[0].delete == nil && changes[0].insert == nil && changes[0].move == nil && changes[0].replace != nil {
            return .update
        }
        // Mixup operation.
        if changes[0].delete != nil && changes[0].insert != nil && changes[0].move == nil && changes[0].replace == nil {
            return .mixup
        }
        
        return .none
    }
    
//    fileprivate func updateItems<T: DiffAware>(old: Array<T>, new: Array<T>){
//    //    mChanges = mChanges as! Array<DiffAware>
//        // FIXME: - WARN TERB.
//        let changes = diff(old: old, new: new)
//
//        switch dataListOperationType{
//        case .none:
//            break
//        case .insert:
//            insertItems(at: changes[0])
//            changes.forEach { j in
//                insertItems(at: IndexPath(row: j.insert!.index, section: 0))
//            }
//
//        case .move:
//            moveItem(at: <#T##IndexPath#>, to: <#T##IndexPath#>)
//
//        case .update:
//
//            break
//        case .delete:
//            deleteItems(at: <#T##[IndexPath]#>)
//
//        case .mixup:
//            break
//        }
//    }
    
}

// MARK: - Outside Method.
extension SGListView{
    
    /**
     Will display event of cell for SGListView.
     - Parameter listener: A handler for click event. `cell` is loaded UICollectionViewCell; `indexPath` is contained section and row data structure.
     */
    public func setOnCellWillDisplayListener(_ listener: @escaping (( _ indexPath: IndexPath) -> Void)){
        setOnCellWillDisplayClosure = { (indexPath) in
            listener(indexPath)
        }
    }
    
    /**
     Click event of cell for SGListView.
     - Parameter listener: A handler for click event. `cell` is loaded UICollectionViewCell; `indexPath` is contained section and row data structure.
     */
    public func setOnCellClickListnenr(_ listener: @escaping ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)){
        setOnCellClickClosure = { (cell, indexPath) in
            listener(cell, indexPath)
        }
    }
    
    /**
     Declick event of cell for SGListView.
     - Parameter listener: A handler for click event. `cell` is loaded UICollectionViewCell; `indexPath` is contained section and row data structure.
     */
    public func setOnCellDeclickListener(_ listener: @escaping ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)){
        setOnCellDeclickClosure = { (cell, indexPath) in
            listener(cell, indexPath)
        }
    }
    
    /**
     Will be executed click event of cell for SGListView.
     - Parameter listener: A handler for click event. `cell` is loaded UICollectionViewCell; `indexPath` is contained section and row data structure.
     */
    public func setOnCellWillClickListener(_ listener: @escaping ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)){
        setOnCellWillClickClosure = { (cell, indexPath) in
            listener(cell, indexPath)
        }
    }
    
    /**
     The click of cell for SGListView has been finished event.
     - Parameter listener: A handler for click event. `cell` is loaded UICollectionViewCell; `indexPath` is contained section and row data structure.
     */
    public func setOnCellFinishClickListener(_ listener: @escaping ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)){
        setOnCellFinishClickClosure = { (cell, indexPath) in
            listener(cell, indexPath)
        }
    }
    
    /**
     Bind cell and data event.
     - Parameter listener: A handler for bind event. `cell` is going to loaded cell; `model` is map to cell's data structure; `indexPath` is contained section and row data structure.
     */
    public func setOnCellDataBindListener(_ listener: @escaping ((_ cell: UICollectionViewCell, _ model: Any, _ indexPath: IndexPath) -> Void)){
        setOnCellDataBindClosure = { (cell, data, indexPath) in
            listener(cell, data, indexPath)
        }
    }
    
    public func getReusableId() -> String{
        return REUSABLE_ID
    }
    
}

// MARK: - UICollectionViewDelegate.
extension SGListView{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if setOnCellClickClosure != nil {
                setOnCellClickClosure!(cell, indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if setOnCellDeclickClosure != nil {
                setOnCellDeclickClosure!(cell, indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if setOnCellWillClickClosure != nil {
                setOnCellWillClickClosure!(cell, indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if setOnCellFinishClickClosure != nil {
                setOnCellFinishClickClosure!(cell, indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) != nil {
            if setOnCellWillDisplayClosure != nil {
                setOnCellWillDisplayClosure!(indexPath)
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource.
extension SGListView{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tempDataList = dataList!

        let cell = dequeueReusableCell(withReuseIdentifier: REUSABLE_ID, for: indexPath)

        if setOnCellDataBindClosure != nil {
            setOnCellDataBindClosure!(cell, tempDataList[indexPath.row], indexPath)
        }
        
        return cell
    }
    
}
