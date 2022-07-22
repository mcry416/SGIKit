//
//  SGListViewTypealias.swift
//  NewNavigationBar
//
//  Created by MengQingyu iMac on 2022/2/9.
//

import UIKit

extension SGListView{
    
    /**
     Set on cell will display event. Using indexPath to action some method.
     - Parameter indexPath: IndexPath as usually.
     - Returns: Void.
     */
    public typealias SetOnCellWillDisplayClosure = (_ indexPath: IndexPath) -> Void

    /**
     To bind cell and outside data source(dataList) with index.
     - Parameter cellClass: Operation cell class.
     - Parameter index: Index for cell.
     - Returns: Void.
     */
    public typealias SetOnCellDataBindClosure = (_ cellClass: UICollectionViewCell, _ model: Any, _ indexPath: IndexPath) -> Void

    /**
     Set on click at cell event. Using indexPath to action some method.
     - Parameter cellClass: Operation cell class.
     - Parameter indexPath: IndexPath as usually.
     - Returns: Void.
     */
    public typealias SetOnCellClickClosure = (_ cellClass: UICollectionViewCell, _ indexPath: IndexPath) -> Void
    
    /**
     Set on declick at cell event. Using indexPath to action some method.
     - Note: Do not mix it up with `SetOnCellFinishClickClosure` method, it's means click event was canceled rather than finish the process.
     - Parameter cellClass: Operation cell class.
     - Parameter indexPath: IndexPath as usually.
     - Returns: Void.
     */
    public typealias SetOnCellDeclickClosure = (_ cellClass: UICollectionViewCell, _ indexPath: IndexPath) -> Void
    
    /**
     Set on will click at cell event. Using indexPath to action some method.
     - Parameter cellClass: Operation cell class.
     - Parameter indexPath: IndexPath as usually.
     - Returns: Void.
     */
    public typealias SetOnCellWillClickClosure = (_ cellClass: UICollectionViewCell, _ indexPath: IndexPath) -> Void
    
    /**
     Set on finish click at cell event. Using indexPath to action some method.
     - Note: Do not mix it up with `SetOnCellDeclickClousre` method, it;s means click event was finished rather than canceled.
     - Parameter cellClass: Operation cell class.
     - Parameter indexPath: IndexPath as usually.
     - Returns: Void.
     */
    public typealias SetOnCellFinishClickClosure = (_ cellClass: UICollectionViewCell, _ indexPath: IndexPath) -> Void
    
}
