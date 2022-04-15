//
//  SGSquareView.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/3/10.
//

import UIKit

class SGSquareView: UIView {
    
    // MARK: - Variables & Constant
    public weak var delegate: SGSquareDelegate?
    
    /// Root scroll view container.
    private lazy var scrollView: UIScrollView = self.createScrollView()
    
    /// Lattices data source.
    private var lattices: Array<SGSquareViewLattice> = Array<SGSquareViewLattice>()
    
    /// Optional title label. The existence of title label and title view are mutually exclusive.
    private lazy var titleLabel: UILabel = self.createTitleLabel()
    
    /// Optional title view. The existence of title label and title view are mutually exclusive.
    private lazy var titleView: UIView = self.createTitleView()
    
    /// Hook of SGSquareView will reload lattices.
    public var willReloadCompletion: (() -> Void)?
    
    /// Hook of SGSquareView did reloaded lattices.
    public var didReloadCompletion: (() -> Void)?
    
    /// Judge the SGSquareView whether is first load, used at method of didMoveToWindow().
    private var isFirstLoad: Int = 0
    
    private var recyclerLattices: Array<SGSquareViewLattice>!
    
    private var latticeClass: AnyClass!
    
    private var _isScrollEnable: Bool = true
    /// Set SGSquareView ScrollView container status of scroll.
    public var isScrollEnable: Bool {
        set{
            _isScrollEnable = newValue
            self.scrollView.isScrollEnabled = _isScrollEnable
        }
        get{
            return _isScrollEnable
        }
    }
    
    private var _isTapToCenter: Bool = false
    /// Set tap action status for Lattice whether will move to center when user tap Lattice, default false.
    public var isTapToCenter: Bool{
        set{
            _isTapToCenter = newValue
        }
        get{
            return _isTapToCenter
        }
    }
    
    private var _isPageEnable: Bool = true
    /// Decide to whether scroll SGSquareView has pageable ability.
    public var isPageEnable: Bool{
        set{
            _isPageEnable = newValue
            self.scrollView.isPagingEnabled = _isPageEnable
        }
        get{
            return _isPageEnable
        }
    }
    
    /// First lattice right padding of SGSqraeView. Defalut 0.
    public var HEAD_OFFSET: CGFloat      = 10
    /// Space between lattices. Defalu 0.
    public var miniLaticeSpace: CGFloat  = 10
    
    /// 10
    private var VIEW_PADDING: CGFloat    = 10
    /// 100
    private let VIEW_DIMENSIONS: CGFloat = 100
    /// 0
    private let VIEWS_OFFSET: CGFloat    = 0
    
    // MARK: - Init.
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        isFirstLoad = isFirstLoad + 1
        if isFirstLoad <= 1 {
            self.initAllWidget()
        }
    }
    
    override var layer: CALayer{
        set{
            layer.masksToBounds = false
            self.layer = newValue
        }
        get{
            return super.layer
        }
    }
    
}

// MARK: - Define life cycle.
extension SGSquareView{
    
    func willReload(){
        if isFirstLoad >= 1 {
            if self.willReloadCompletion != nil{
                self.willReloadCompletion!()
            }
        }
    }
    
    func didReload(){
        if isFirstLoad >= 1 {
            if self.didReloadCompletion != nil {
                self.didReloadCompletion!()
            }
        }
    }
    
}

// MARK: - Init scrollView & widget.
extension SGSquareView{
    
    fileprivate func initAllWidget(){
        
        self.reload()
        
        if let delegate = self.delegate {
            // titleLabel or titleView height, used to confirm the y value of the scrollView.
            var headHeight: CGFloat = 0
            
            let isExistTitleLabel: Bool = (delegate.titleForSGSquareView?(self) != nil &&
                                           delegate.titleForSGSquareView?(self) != "")
            let isExistTitleView: Bool = (delegate.titleViewForSGSquareView?(self) != nil &&
                                          delegate.titleViewForSGSquareView?(self).frame != nil &&
                                          delegate.titleViewSizeForSGSquareView?(self) != .zero)
            let isExistTitleLabelSize: Bool = (delegate.titleSizeForSGSquareView?(self) != .zero)
            let isExistTitleViewSize: Bool = (delegate.titleViewSizeForSGSquareView?(self) != .zero)
            
            // To avoid same view was added into SGSquareView.
            assert((isExistTitleLabel && !isExistTitleView) ||
                   (!isExistTitleLabel && isExistTitleView) ||
                   (!isExistTitleLabel && !isExistTitleView), "Can not implement method of titleForSGSquareView and titleViewForSGSquareView together.")
            
            // To avoid nil operation for delagte.
            assert((isExistTitleLabelSize && !isExistTitleLabel) ||
                   (!isExistTitleLabelSize && isExistTitleLabel) ||
                   (!isExistTitleLabelSize && !isExistTitleLabel), "SGSquareView must implement method of titleForSGSquareView.")
            assert((isExistTitleViewSize && !isExistTitleView) ||
                   (!isExistTitleViewSize && isExistTitleView) ||
                   (!isExistTitleViewSize && !isExistTitleView), "SGSquareView must implement method of titleViewForSGSquareView.")
            
            // Using concrete attribute to calculate the height of whose located in row.
            if isExistTitleLabelSize {
                let increaseTitleLabelHeight = delegate.titleSizeForSGSquareView?(self).height
                headHeight = headHeight + increaseTitleLabelHeight!
            } else if (delegate.titleForSGSquareView?(self)) != ""{
                let increaseTitleLabelHeight: CGFloat = 30
                headHeight = headHeight + increaseTitleLabelHeight
            }
            
            // Using concrete attribute to calculate the height of whose located in row.
            if isExistTitleViewSize {
                let increaseTitleViewHeight = delegate.titleViewSizeForSGSquareView?(self).height
                headHeight = headHeight + increaseTitleViewHeight!
            } else if(delegate.titleViewForSGSquareView?(self) != nil) {
                let increaseTitleViewHeight = delegate.titleViewForSGSquareView?(self).frame.height
                headHeight = headHeight + increaseTitleViewHeight!
            }

            if isExistTitleLabel {
                self.initTitle()
            }
            
            if isExistTitleView {
                self.initTitleView()
            }

            self.scrollView.frame = CGRect(x: self.scrollView.frame.minX,
                                           y: headHeight,
                                           width: self.scrollView.frame.width,
                                           height: self.frame.height - headHeight)

            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height - headHeight)
        }
    }
    
    fileprivate func initScrollView(){
        self.addSubview(scrollView)

        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapEvent(_:)))
        scrollView.addGestureRecognizer(tap)
    }
    
    fileprivate func initTitle(){
        if let delegate = self.delegate {
            let title = delegate.titleForSGSquareView?(self)
            self.titleLabel.text = title
            self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
            self.addSubview(titleLabel)
        }
    }
    
    fileprivate func initTitleView(){
        if let delegate = self.delegate {
            let titleView = delegate.titleViewForSGSquareView?(self)
            self.titleView = titleView!
            self.addSubview(self.titleView)
        }
    }
    
    fileprivate func setSizeForTitle(){
        if let delegate = self.delegate {
            let size = delegate.titleSizeForSGSquareView?(self)
            self.titleLabel.frame.size = size!
        }
    }
    
    fileprivate func setSizeForTitleView(){
        if let delegate = self.delegate {
            let size = delegate.titleViewSizeForSGSquareView?(self)
            self.titleView.frame.size = size!
        }
    }
    
}

// MARK: - Lazy Load.
extension SGSquareView{
    
    fileprivate func createScrollView() -> UIScrollView{
        let scroll = UIScrollView()
        return scroll
    }
    
    fileprivate func createTitleLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }
    
    fileprivate func createTitleView() -> UIView{
        let view = UIView()
        return view
    }
    
}

// MARK: - Event Process.
extension SGSquareView{
    
    /// Determine which item was clicked by comparing the click event position and the scrollView subviews position.
    @objc fileprivate func scrollViewTapEvent(_ gesture: UITapGestureRecognizer){
        let location = gesture.location(in: gesture.view)
        
        if let delegate = self.delegate {
            for index in 0..<delegate.numberOfItemForSGSquareView(self) {
                let view = scrollView.subviews[index] as UIView
                
                // If lattice frame containes tap point
                if view.frame.contains(location) {
                    delegate.sgSquareViewClickedAtIndex(self, index: index)
                    
                    // According to @isTapToCenter dicide to whether tap it will move to center.
                    if isTapToCenter {
                        scrollView.setContentOffset(CGPoint(x: (view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2), y: 0), animated: true)
                    }
                    break
                }
            }
        }
        
    }
    
    /// Return a lattice by index.
    fileprivate func latticeAtIndex(index: Int) -> SGSquareViewLattice{
        return lattices[index]
    }
    
    /// Reload items.
    public func reload(){
        self.willReload()
        // Check the delegate whether equals concrete delegate.
        if let delegate = self.delegate {
            // When method of reload was called, lattices ought to remove all lattices avoid to replicate add.
            lattices.removeAll()
            
            // Get all subsviews from srollView and put it into views.
            let views: Array = scrollView.subviews
            
            // Enumrated the obejct in views and remove itself from views.
            for object in views {
                object.removeFromSuperview()
            }

          //  var xValue = VIEWS_OFFSET
            var xValue: CGFloat = 0
            for index in 0..<delegate.numberOfItemForSGSquareView(self) {
                xValue = HEAD_OFFSET + xValue
            //    let view = delegate.sgSquareView(self, latticeForItemAt: index)
                let view = delegate.sgSquareViewAtIndex(self, index: index)
                view.frame = CGRect(x: xValue,
                                    y: 0,
                                    width: view.frame.width,
                                    height: view.frame.height)
                self.scrollView.addSubview(view)

                // X value of next lattice equal to forward width plus space and plus forward lattice frame of x.
                xValue = view.frame.width + miniLaticeSpace + xValue
                lattices.append(view)
            }
            
            scrollView.contentSize = CGSize(width: (xValue + VIEWS_OFFSET),
                                            height: self.frame.size.height - 30)
            
        }
        self.didReload()
    }
    
    fileprivate func centerCurrentView(){
        var xFinal = scrollView.contentOffset.x + CGFloat((VIEWS_OFFSET / 2) + VIEW_PADDING)
        let viewIndex = xFinal / CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING)))
        xFinal = viewIndex * CGFloat(VIEW_DIMENSIONS + (2 * VIEW_PADDING))
        scrollView.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        if let delegate = self.delegate {
            delegate.sgSquareViewClickedAtIndex(self, index: Int(viewIndex))
        }
    }
    
    /**
     Dequeue  a recycler lattice for SGSquareView.
     - Default dequeue same type lattice.
     - Show a series lattices from showen pool, dequeue from unshowen pool.
     - Returns: SGSquareViewLattice, recycler instance.
     */
    public func dequeueRecyclerLattice() -> SGSquareViewLattice{
        ///       let latticeClass = recyclerLattices.first as! SGSquareViewLattice
        
//        if (recyclerLattices.first != nil) {
//            recyclerLattices.remove(at: 0)
//            return recyclerLattices[0]
//        } else {
//            latticeClass: SGSquareViewLattice = SGSquareViewLattice()
//            return latticeClass
//        }
        return SGSquareViewLattice()
    }
    
}

// MARK: - UIScrollViewDelegate.
extension SGSquareView: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if false {
    //        self.centerCurrentView()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if false {
            if !decelerate {
      //          self.centerCurrentView()
            }
        }
    }
    
}
