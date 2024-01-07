//
//  SGTableView.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/2/14.
//

/*
import UIKit

/// Judge the source of init method.
enum InitSource {
    case customeStyle
    case innerStyle
}

/**
 To bind cell and data by indexPath.
 - Parameter cellClass: Cell class.
 - Parameter data: Double inner Array of custom model.
 - Returns Void.
 */
typealias SetCellDataBinding = (_ cellClass: UITableViewCell, _ data: Any) -> Void

/**
 Set on click at cell event. Using indexPath to action some method not change itself attributes.
 - Parameter indexPath: IndexPath as usually.
 - Returns Void.
 */
typealias SetOnCellClickListener = (_ indexPatn: IndexPath) -> Void

class SGTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
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
    
    private let CGRectZero =  CGRect(x: 0, y: 0, width: 0, height: 0)
    
    public var dataList: Array<Array<Any>>?
    
    /// Estimated height not concretae height at runtime.
    public var estimatedHeightForRow: CGFloat!
    
    private var rowHeightOfSGtableView: CGFloat!
    
    private var cellClass: AnyClass!
    
    /// Type of InitSource. When outside called convenience method, which could judge the source of init method.
    private var initSource: InitSource?
    
    /// Type of UITableViewCell.CellStyle, which decide to inner class style.
    private var cellStyle: UITableViewCell.CellStyle?

    // MARK: - Override init.
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRectZero, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init configuration.
    private func initConfig(cellClass: AnyClass){
        self.delegate = self
        self.dataSource = self
        self.register(cellClass, forCellReuseIdentifier: "MY_CELL")
    }
    
    private func initAsSuper(frame: CGRect){
        self.frame = frame
    }
    
    private func setInitSource(initSource: InitSource){
        self.initSource = initSource
    }
    
    private func initRowHeight(height: CGFloat){
        self.estimatedHeightForRow = height
        self.rowHeightOfSGtableView = height
    }
    
    private func initData(data: Any){
        self.dataList = data as! Array<Array<Any>>
    }
    
    private func initCellStyle(cellStyle: UITableViewCell.CellStyle){
        self.cellStyle = cellStyle
        self.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "MY_CELL")
    }
    
    // MARK: - SGTableView init.
    /**
     Convenience init of cell class , frame and rowHeight, suit for custome cell.
     - Parameter cellClass: Cell class of UITableViewCell.
     - Parameter frame: Frame of SGTableView.
     - Parameter rowHeight: Type of CGFloat, concreate row for row.
     */
    convenience init(cellClass: AnyClass, frame: CGRect, rowHeight: CGFloat) {
        self.init()
        self.setInitSource(initSource: .customeStyle)
        self.initConfig(cellClass: cellClass)
        self.initAsSuper(frame: frame)
        self.initRowHeight(height: rowHeight)
    }
    
    /**
     Convenience init of UITableView inner style.
     - Parameter cellStyle: Default four type of UITableViewCellStyle.
     - Parameter frame: Frame of SGTableView.
     - Parameter dataSource: Type of double layer Array to store variables.
     */
    convenience init(cellStyle: UITableViewCell.CellStyle, frame: CGRect, dataSource: Array<Array<Any>>) {
        self.init()
        self.setInitSource(initSource: .innerStyle)
        self.initCellStyle(cellStyle: cellStyle)
        self.initAsSuper(frame: frame)
        self.initData(data: dataSource)
    }

}

// MARK: UITableViewDataSource.
extension SGTableView{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempList = self.dataList!
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MY_CELL", for: indexPath)
        if initSource == .customeStyle {
            setCellDataBinding!(cell, tempList[indexPath.section][indexPath.row])
            return cell
        }
        if initSource == .innerStyle {
            cell = UITableViewCell.init(style: self.cellStyle!, reuseIdentifier: "MY_CELL")
            setCellDataBinding!(cell, tempList[indexPath.section][indexPath.row])
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeightOfSGtableView
    }
}

// MARK: - UITableViewDelegate.
extension SGTableView{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setOnCellClickListener!(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.estimatedHeightForRow == nil) {
            return 130
        }
        return self.estimatedRowHeight
    }
}

*/
