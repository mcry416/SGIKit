//
//  SGIntroduceTitleAdapter.swift
//  LabelTEST
//
//  Created by MengQingyu iMac on 2023/3/2.
//

import UIKit

open class SGIntroduceTitleAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var titleDidScrollBlock: ((_ index: Int) -> Void)?
    public var titleDidSelectBlock: ((_ model: SGIntroduceTitleModel) -> Void)?
    
    private var cellId: String!
    private var dataList: Array<SGIntroduceTitleModel>!
    private var lastOffset: CGFloat = 0
    private var isScrollToLeft: Bool = false
    
    init(cellId: String, dataList: Array<SGIntroduceTitleModel>){
        self.cellId = cellId
        self.dataList = dataList
    }
    
    public func update(dataList: Array<SGIntroduceTitleModel>){
        self.dataList = dataList
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! SGIntroduceTitleCell
        
        cell.setCell(self.dataList[indexPath.row])
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        isScrollToLeft ? titleDidScrollBlock?(indexPath.row + 1) : titleDidScrollBlock?(indexPath.row - 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        titleDidSelectBlock?(dataList[indexPath.row])
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.isScrollToLeft = self.lastOffset < scrollView.contentOffset.x
        
        self.lastOffset = scrollView.contentOffset.x
    }

}
