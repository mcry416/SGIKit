//
//  SGListViewTypealias.swift
//  NewNavigationBar
//
//  Created by MengQingyu iMac on 2022/2/9.
//

import UIKit

extension SGListView{

    /**
     To bind cell and outside data source(dataList) with index.
     - Parameter cellClass: Cell class.
     - Parameter index: Index for cell.
     - Returns: Void.
     */
    public typealias SetOnCellDataBindClosure = (_ cellClass: UICollectionViewCell, _ model: Any, _ indexPath: IndexPath) -> Void

    /**
     Set on click at cell event. Using indexPath to action some method not change itself attributes.
     - Parameter indexPath: IndexPath as usually.
     - Returns: Void.
     */
    public typealias SetOnCellClickClosure = (_ cellClass: UICollectionViewCell, _ indexPath: IndexPath) -> Void
    
}
