//
//  SGIntroduceImageAdapter.swift
//  LabelTEST
//
//  Created by MengQingyu iMac on 2023/3/2.
//

import UIKit

open class SGIntroduceImageAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var imageDidScrollBlock: ((_ index: Int) -> Void)?
    
    private var cellId: String!
    private var dataList: Array<SGIntroduceImageModel>!
    private var lastOffset: CGFloat = 0
    private var isScrollToLeft: Bool = false
    
    init(cellId: String, dataList: Array<SGIntroduceImageModel>){
        self.cellId = cellId
        self.dataList = dataList
    }
    
    public func update(dataList: Array<SGIntroduceImageModel>){
        self.dataList = dataList
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! SGIntroduceImageCell
        
        cell.setCell(self.dataList[indexPath.row])
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        isScrollToLeft ? imageDidScrollBlock?(indexPath.row + 1) : imageDidScrollBlock?(indexPath.row - 1)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.isScrollToLeft = self.lastOffset < scrollView.contentOffset.x
        
        self.lastOffset = scrollView.contentOffset.x
    }

}
