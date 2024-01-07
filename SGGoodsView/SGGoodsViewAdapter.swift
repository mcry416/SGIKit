//
//  SGGoodsViewAdapter.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/2.
//

import UIKit

open class SGGoodsViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private var id: String!
    private var datas: Array<SGGoodsModel>!
    
    public var cellSelectAction: ((_ index: Int) -> Void)?
    public var cellDeselectAction: ((_ index: Int) -> Void)?
    
    init(datas: Array<SGGoodsModel>, id: String){
        self.datas = datas
        self.id = id
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! SGGoodsCell
        
        if datas[indexPath.row].imageName != nil {
            cell.imageView.image = UIImage(named: datas[indexPath.row].imageName)
        }
        if datas[indexPath.row].image != nil {
            cell.imageView.image = datas[indexPath.row].image
        }
        if datas[indexPath.row].urlName != nil {

        }
        
        cell.imageView.contentMode = datas[indexPath.row].contentMode
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cellSelectAction != nil{
            cellSelectAction!(indexPath.row)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if cellDeselectAction != nil{
            cellDeselectAction!(indexPath.row)
        }
    }

}
