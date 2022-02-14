//
//  SGListViewTypealias.swift
//  NewNavigationBar
//
//  Created by MengQingyu iMac on 2022/2/9.
//

import UIKit

/**
 To bind cell and data by indexPath.
 - Parameter cellClass: Cell class.
 - Parameter data: Double inner Array of custom model.
 - Returns Void.
 */
typealias SetCellDataBinding = (_ cellClass: UICollectionViewCell, _ data: Any) -> Void

/**
 To bind cell and outside data source(dataList) with index.
 - Parameter cellClass: Cell class.
 - Parameter index: Index for cell.
 - Returns Void.
 */
typealias SetCellDataBindingWthIndex = (_ cellClass: UICollectionViewCell, _ index: Int) -> Void

/**
 Set on click at cell event. Using indexPath to action some method not change itself attributes.
 - Parameter indexPath: IndexPath as usually.
 - Returns Void.
 */
typealias SetOnCellClickListener = (_ indexPath: IndexPath) -> Void
