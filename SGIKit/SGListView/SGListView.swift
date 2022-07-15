//
//  SGListView.swift
//  FifthNavigation
//
//  Created by MengQingyu iMac on 2022/1/20.
//

import UIKit

class SGListView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
    private var setOnCellClickClosure: SetOnCellClickClosure?
    
    /// Declick event of cell for UICollectionView.
    private var setOnCellDeclickClosure: SetOnCellDeclickClosure?
    
    /// Will click event of cell for UICollectionView.
    private var setOnCellWillClickClosure: SetOnCellWillClickClosure?
    
    /// The click event has been finished event of cell for UICollectionView.
    private var setOnCellFinishClickClosure: SetOnCellFinishClickClosure?
    
    /// To bind cell and outside data source(dataList) with index.
    private var setOnCellDataBindClosure: SetOnCellDataBindClosure?
    
    /// Wehther the cell should be display.
    private var setOnCellWhetherClickClosure: SetOnCellWhetherClickClosure?
    
    /// SGListView data list, which will set delegate and dataSource to SGListView itself while didiSet, consequentlly it could be initing and defining safely when used.
    public var dataList: Array<Array<Any>>?{
        didSet{
            self.delegate = self
            self.dataSource = self
        }
    }
    
    ///  Generate reusable id when did set. eg. `SLV_MYCELL_528`.
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
    
    // MARK: - Init configuration.
    private final func initConfig(cellClass: AnyClass, reusableId: String){
        self.register(cellClass, forCellWithReuseIdentifier: reusableId)
        
    }
    
    private final func initDirection(direction: ListViewDirection){
        layoutItem = UICollectionViewFlowLayout()
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

// MARK: - Outside Method.
extension SGListView{
    
    /**
     Wehther the cell could be action the click event.
     - Parameter listener: A handler for click event. `indexPath` is contained section and row data structure.
     */
    public func setOnCellWhetherClickListener(_ listener: @escaping ((_ indexPath: IndexPath) -> Bool)){
        setOnCellWhetherClickClosure = { (indexPath) in
            return listener(indexPath)
        }
    }
    
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
        let cell = collectionView.cellForItem(at: indexPath)!
        
        setOnCellClickClosure!(cell, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        setOnCellDeclickClosure!(cell, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        setOnCellWillClickClosure!(cell, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        setOnCellFinishClickClosure!(cell, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return setOnCellWhetherClickClosure!(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setOnCellWillDisplayClosure!(indexPath)
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

        // Only outside index was availiable.
        if setOnCellDataBindClosure != nil {
            setOnCellDataBindClosure!(cell, tempDataList[indexPath.section][indexPath.row], indexPath)
        }
        
        return cell
    }
    
}
