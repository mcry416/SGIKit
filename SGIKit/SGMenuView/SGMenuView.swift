//
//  SGMenuView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/6/23.
//

import UIKit

/**
 A popup window style menu  view, fill cell with `Menu1Model`.
 - Note: Its inherited from NSObject rathan than UIView,cconsuequentlly the subviews is added into `UIWindow` directly.
 */
class SGMenuView: NSObject {
    
    enum ShowType {
        case standard
    }
    
    let MENU_CELL_ID = "MENU_CELL_ID"
    /// SGMenuView's right and left padding for screen.
    let padding: CGFloat = 12
    ///
    let bottomPadding: CGFloat = 40
    
    private lazy var backgroundView: UIView = self.createBackgroundView()
    private lazy var contentView: UIView = self.createContentView()
    private lazy var collectionView: UICollectionView = self.createCollectionView()
    
    private var menuClickAction:      ((_ index: Int) -> Void)?
    private var menuLongClickAction:  (( _ index: Int) -> Void)?
    private var menuCloseAction:      (() -> Void)?
    
    public var showType: ShowType = .standard
    
    public var datas: Array<Menu1Model> = Array<Menu1Model>()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(datas: Array<Menu1Model>) {
        self.init()
        
        _initView(datas: datas)
    }

}

// MARK: - Listener.
extension SGMenuView{
    
    /**
     Listener the action when use click the menu item.
     - Parameter handler: Provide a index for user to operation.
     */
    public func setOnMenuClickListener(handler: @escaping ((_ index: Int) -> Void)){
        menuClickAction = { (index) in
            handler(index)
        }
    }
    
    /**
     Listener the action when use close the menu view.
     */
    public func setOnMenuCloseListener(handler: @escaping (() -> Void)){
        menuCloseAction = {
            handler()
        }
    }
    
}

// MARK: - UI.
extension SGMenuView{
    
    fileprivate func _initView(datas: Array<Menu1Model>){
        self.contentView.layer.cornerRadius = 10

        let window = UIApplication.shared.keyWindow
        window?.addSubview(backgroundView)
        window?.addSubview(contentView)
        contentView.addSubview(collectionView)
        
        self.datas = datas
        
        // Provide an original frame for contentView to show in the screen when it was showed.
        // It should be under the screen bottom to use the animation.
        let originalShowStageFrame: CGRect = CGRect(x: padding,
                                                    y: kScreenHeight(),
                                                    width: kScreenWidth() - (padding * 2),
                                                    height: 100)
        contentView.frame = originalShowStageFrame
        collectionView.frame = CGRect(origin: .zero, size: contentView.frame.size)
        
        
        // If data's count was less than 5, then use the min frame, otherwise use the max frame.
        var conditionFrame: CGRect = .zero
        if self.datas.count > 5 {
            conditionFrame = CGRect(x: padding,
                                y: kScreenHeight() - kBottomPadding() - 210,
                                width: kScreenWidth() - (padding * 2),
                                height: 210)
        } else {
            conditionFrame = CGRect(x: padding,
                                y: kScreenHeight() - kBottomPadding() - 110,
                                width: kScreenWidth() - (padding * 2),
                                height: 110)
        }
        
        // Data has been filled, set delegate.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // SGMenuView has been showed in the screen bottom, and now let it move to the position of `conditionFrame`.
        // Notice the collectionView also ought to decrease `yPadding` to let it to be beautiful.
        UIView.animate(withDuration: 0.618, delay: 0, usingSpringWithDamping: 0.618, initialSpringVelocity: 0.382, options: .curveEaseInOut) {
            let yPadding: CGFloat = 5
            self.contentView.frame = conditionFrame
            self.collectionView.frame = CGRect(x: 0,
                                               y: yPadding,
                                               width: self.contentView.frame.width,
                                               height: self.contentView.frame.height - yPadding * 2)
        } completion: { (true) in
            
        }

    }
    
    fileprivate func createCollectionView() -> UICollectionView{
        let flowLayout = UICollectionViewFlowLayout()
        // Make sure the cell in the screen has 5 only rathan using concretely frame.
        flowLayout.itemSize = CGSize(width: vWidth() / 6, height: (vWidth() / 6) + 27)
        
        let collectionView = UICollectionView(frame: CGRect(origin: .zero,
                                                            size: contentView.frame.size),
                                              collectionViewLayout: flowLayout)
        collectionView.register(Menu1Cell.self, forCellWithReuseIdentifier: MENU_CELL_ID)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        return collectionView
    }
    
    fileprivate func createBackgroundView() -> UIView{
        let view = UIView(frame: .zero)
        view.frame = UIApplication.shared.keyWindow?.bounds ?? .zero
        view.backgroundColor = .black.withAlphaComponent(0.4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideSGMenuView))
        view.addGestureRecognizer(tap)
        return view
    }
    
    fileprivate func createContentView() -> UIView{
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }
    
    @objc fileprivate func removeSGMenuView(){
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0
        } completion: { (true) in
            self.backgroundView.removeFromSuperview()
            self.contentView.removeFromSuperview()
        }
    }
    
    @objc fileprivate func hideSGMenuView(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [self] in
            let hideStageFrame: CGRect = CGRect(x: self.padding,
                                                y: self.kScreenHeight(),
                                                width: self.kScreenWidth() - (self.padding * 2),
                                                height: 100)
            self.contentView.frame = hideStageFrame
            self.contentView.alpha = 0
        } completion: { (true) in
            
        }

        if menuCloseAction != nil {
            menuCloseAction!()
        }
        self.perform(#selector(self.removeSGMenuView), with: nil, afterDelay: 0.3)
    }
    
    /// SGMenuView width.
    fileprivate func vWidth() -> CGFloat{
        return kScreenWidth() - (padding * 2)
    }
    /// SGMenuView height, gold rate.
    fileprivate func vHeight() -> CGFloat{
        return (vWidth() * 0.618)
    }
    /// Screen width.
    fileprivate func kScreenWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    /// Screen height.
    fileprivate func kScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    fileprivate func kBottomPadding() -> CGFloat{
        return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + 49
    }
    
}

// MARK: - UICollectionViewDataSource & Delegate.
extension SGMenuView: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MENU_CELL_ID, for: indexPath) as! Menu1Cell
        
        cell.image.image = UIImage(named: datas[indexPath.row].imageName)
        cell.label.text = datas[indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menuClickAction != nil {
            menuClickAction!(indexPath.row)
        }
    }
    
}
