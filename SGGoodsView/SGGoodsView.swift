//
//  SGGoodsView.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/2.
//

import UIKit
import CoreMedia

open class SGGoodsView: UIView {
    
    private let GOODS_VIEW_CELL_ID = "GV_ID"
    private var datas: Array<SGGoodsModel>!
    private var goodsAdapter: SGGoodsViewAdapter!
    
    private lazy var collectionView: UICollectionView = self.createUICollectionView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Not implement.")
    }
    
    open override var frame: CGRect{
        didSet{
            collectionView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: frame.width,
                                     height: frame.height)
        }
    }
    
    open override var backgroundColor: UIColor?{
        didSet{
            collectionView.backgroundColor = backgroundColor ?? .white
        }
    }

}

// MARK: - Build
extension SGGoodsView{
    
    public func fill(imageName: String, contentMode: UIImageView.ContentMode = .scaleToFill) -> Self{
        if datas == nil {
            datas = Array<SGGoodsModel>()
        }
        datas.append(SGGoodsModel(imageName: imageName, contentMode: contentMode))
        return self
    }
    
    public func fill(urlName: String, contentMode: UIImageView.ContentMode = .scaleToFill) -> Self{
        if datas == nil {
            datas = Array<SGGoodsModel>()
        }
        datas.append(SGGoodsModel(urlName: urlName, contentMode: contentMode))
        return self
    }
    
    public func fill(image: UIImage, contentMode: UIImageView.ContentMode = .scaleToFill) -> Self{
        if datas == nil {
            datas = Array<SGGoodsModel>()
        }
        datas.append(SGGoodsModel(image: image, contentMode: contentMode))
        return self
    }
    
    public func builder() -> Self{
        goodsAdapter = SGGoodsViewAdapter(datas: datas, id: getId())
        collectionView.delegate = goodsAdapter
        collectionView.dataSource = goodsAdapter
        self.layer.masksToBounds = true
        self.addSubview(collectionView)
        
        return self
    }
    
    public func setOnGoodsClickListener(_ listener: ((_ index: Int) -> Void)?){
        goodsAdapter.cellSelectAction = { (index) in
            if listener != nil {
                listener!(index)
            }
        }
    }
    
    public func setOnGoodsDeclickListener(_ listener: ((_ index: Int) -> Void)?){
        goodsAdapter.cellDeselectAction = { (index) in
            if listener != nil {
                listener!(index)
            }
        }
    }
    
}

// MARK: - View.
extension SGGoodsView{
    
    fileprivate func createUICollectionView() -> UICollectionView{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kSCREEN_WIDTH, height: kSCREEN_WIDTH)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(SGGoodsCell.self, forCellWithReuseIdentifier: getId())
        collectionView.backgroundColor = .white
        
        return collectionView
    }
    
    fileprivate func getId() -> String{
        return "\(GOODS_VIEW_CELL_ID)_\(String(self.hashValue).prefix(6))"
    }
    
}
