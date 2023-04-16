//
//  SGIntroduceView.swift
//  LabelTEST
//
//  Created by MengQingyu iMac on 2023/3/2.
//

import UIKit

class SGIntroduceView: UIView {
    
    public var imagesColor: UIColor {
        set { scrollImage.backgroundColor = newValue }
        get { scrollImage.backgroundColor ?? .white }
    }
    
    public var titlesColor: UIColor {
        set { scrollTitle.backgroundColor = newValue }
        get { scrollTitle.backgroundColor ?? .white }
    }
    
    public var buttonTitle: String {
        set { nextButton.setTitle(newValue, for: .normal) }
        get { nextButton.titleLabel?.text ?? "" }
    }

    private lazy var scrollImage: UICollectionView = self.createScrollImage()
    private lazy var scrollTitle: UICollectionView = self.createScrollTitle()
    private lazy var nextButton:  UIButton         = self.createNextButton()
    
    private lazy var imageAdapter: SGIntroduceImageAdapter = self.createScrollImageAdapter()
    private lazy var titleAdapter: SGIntroduceTitleAdapter = self.createScrollTitleAdapter()
    
    private var offset1: CGFloat = 0
    private var offset2: CGFloat = 0
    
    private let SG_SCROLL_IMAGE: String = "SG_SCROLL_IMAGE"
    private let SG_SCROLL_TITLE: String = "SG_SCROLL_TITLE"
    
    private var imageDataList: Array<SGIntroduceImageModel> = Array<SGIntroduceImageModel>()
    private var titleDataList: Array<SGIntroduceTitleModel> = Array<SGIntroduceTitleModel>()
    
    public var titleDidSelectBlock: ((_ model: SGIntroduceTitleModel) -> Void)?
    
    init(offset1: CGFloat, offset2: CGFloat, frame: CGRect){
        self.offset1 = offset1
        self.offset2 = offset2
        super.init(frame: frame)
        
        self.addSubview(scrollTitle)
        self.addSubview(scrollImage)
        self.addSubview(nextButton)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setDataLists(imageDataList: Array<SGIntroduceImageModel>, titleDataList: Array<SGIntroduceTitleModel>){
        self.imageAdapter.update(dataList: imageDataList)
        self.titleAdapter.update(dataList: titleDataList)
        self.scrollImage.reloadData()
        self.scrollTitle.reloadData()
    }
    
    @objc private func setOnNextButtonListener(){
        let indexPath: IndexPath = self.scrollImage.indexPathsForVisibleItems[0]
        if (indexPath.row + 1) == self.scrollImage.numberOfItems(inSection: 0) {
            self.scrollImage.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        } else {
            self.scrollImage.scrollToItem(at: IndexPath(row: indexPath.row + 1, section: 0), at: .left, animated: true)
        }
    }

}

extension SGIntroduceView {
    
    private func initView(){
        self.backgroundColor = .white
        self.scrollTitle.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 130)
        self.scrollImage.frame = CGRect(x: 0, y: self.scrollTitle.frame.maxY + offset1, width: self.frame.width, height: 200)
        self.nextButton.frame = CGRect(x: 20, y: self.scrollImage.frame.maxY + offset2, width: self.frame.width - 40, height: 40)
    }
    
    private func createScrollImage() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = CGFLOAT_MIN
        layout.itemSize = CGSize(width: self.frame.width, height: 200)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.register(SGIntroduceImageCell.self, forCellWithReuseIdentifier: self.SG_SCROLL_IMAGE)
        view.dataSource = self.imageAdapter
        view.delegate = self.imageAdapter
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        imageAdapter.imageDidScrollBlock = { [weak self] index in
            guard let `self` = self else { return }
            self.scrollTitle.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        }
        
        return view
    }
    
    private func createScrollImageAdapter() -> SGIntroduceImageAdapter {
        SGIntroduceImageAdapter(cellId: self.SG_SCROLL_IMAGE, dataList: self.imageDataList)
    }
    
    private func createScrollTitle() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = CGFLOAT_MIN
        layout.itemSize = CGSize(width: self.frame.width, height: 130)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.register(SGIntroduceTitleCell.self, forCellWithReuseIdentifier: self.SG_SCROLL_TITLE)
        view.dataSource = self.titleAdapter
        view.delegate = self.titleAdapter
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        titleAdapter.titleDidScrollBlock = { [weak self] index in
            guard let `self` = self else { return }
            self.scrollImage.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        }
        
        return view
    }
    
    private func createScrollTitleAdapter() -> SGIntroduceTitleAdapter {
        let adapter = SGIntroduceTitleAdapter(cellId: self.SG_SCROLL_TITLE, dataList: self.titleDataList)
        adapter.titleDidSelectBlock = { model in
            self.titleDidSelectBlock?(model)
        }
        return adapter
    }
    
    private func createNextButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(setOnNextButtonListener), for: .touchUpInside)
        return button
    }
    
}
