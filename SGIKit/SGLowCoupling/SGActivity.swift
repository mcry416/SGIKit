//
//  SGActivity.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/16.
//

import UIKit
import AVFoundation

/**
 SGLowCoupling basic UI container, which is inherited from UIScrollView to organize and manage sub items.
 
 - Example code:
 ```
 let activity = SGActivity(frame: CGRect())
 var activityModel = ActivityModel()
 activity.activityDelegate = activityModel
 self.view.addSubview(activity)
 ```
 - Note: Property 'activityDelegate' must be assigned before SGActivity was added into superview.
 */
class SGActivity: UIScrollView {
    
    /// Delegate for SGActivity.
    public var activityDelegate: SGActivityDelegate?
    
    /// Inside fragments collection, which contains organizational form for SGItem.
    public var fragments: Array<SGFragment> = Array<SGFragment>()
    
    /// Inside vice fragment cache.
    private var viceFragment: SGFragment?
    
    /// Inside top fragment cache.
    private var topFragment: SGFragment?
    
    /// Inside bottom fragment cache.
    private var bottomFragment: SGFragment?
    
    ///
    private var placeholderFragment: SGFragment?
    
    private var isActiveCount: Int = 0
    
    /// Inside items collection.
    public var items: Array<SGItem> = Array<SGItem>()
    
    /// The activity whether in portrait model.
    private var isInPortraitMode: Bool = true
    
    /// The original item width that loaded in activity firstly, be used for rotated screen.
    private var originalItemWidth: CGFloat = 0
    
    public var isScrollToTopTouchOff: Bool = false
    
    internal var bottomRefreshControl: UIRefreshControl?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        guard self.superview != nil else { return }

        _reload()
    }
    
}

// MARK: - Init.
extension SGActivity{
    
    private final func _initView(){
        // Delegate for SGActivityRefresh.
        self.delegate = self
    }
    
    // MARK: - Reload.
    // When SGActivity instance was push or removed from superview and execute this method.
    // The `fragments` is plain fragment collection, not contains top fragment, bottom fragment, and vice fragment,
    // add, delete and others operation for SGActivity instance is avaliable for fragments only.
    // Note: First time the SGActivity insatance will execute this method from delegate, and reads objects into caches,
    //       subsquent operations will read object from caches rather than delegate consequentlly.
    private final func _reload(){
        
        isInPortraitMode = self.frame.width >= kSCREEN_HEIGHT
        
        if let activityDelegate = self.activityDelegate {
            fragments.removeAll()
            items.removeAll()
            
            let views: Array = self.subviews
            
            for object in views {
                object.removeFromSuperview()
            }
            
            var yValue: CGFloat = 0
            // Get activity's frament count.
            for index in 0..<activityDelegate.numberOfSGFragmentForSGActivity(self) {
                
                
                // Get outmost layer framgent by index.
                let fragment = activityDelegate.fragmentAtIndex?(self, index: index)
                if fragment!.isActive {
                    isActiveCount += 1
                }
                assert(isActiveCount <= 2, "The property of `isActive` max count for fragments is 1.")
                
                let sideSpacing: CGFloat = fragment?.sideSpacing ?? 0
                if let fragmentDelegate = fragment?.delegate {
                    
                    // Enumerated current fragment to get sub item.
                    for itemIndex in 0..<fragmentDelegate.numberOfItemForFragment(fragment!) {
                        
                        // Get current fragment's sub item by index.
                        let subItem = fragmentDelegate.itemAtIndex(itemIndex, fragment: fragment!)
                        
                        // Store the original width for the screen was rotated.
                        subItem.originalWidth = subItem.frame.width
                        
                        subItem.frame = CGRect(x: (sideSpacing / 2),
                                               y: yValue,
                                               width: subItem.frame.width - sideSpacing,
                                               height: subItem.frame.height)
                        
                        // Execute bind protocol.
                        if subItem.bundle != nil {
                            subItem.bindBundle(subItem.bundle)
                        }
                        
                        // Set animated for fragment which was located in here.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            subItem.alpha = 0
                            UIView.animate(withDuration: fragment?.animatedInterval ?? 0) {
                                subItem.alpha = 1
                            }
                        }
                        
                        self.addSubview(subItem)
                        items.append(subItem)
                        
                        // Accumulation sub item height to get yValue.
                        yValue = subItem.frame.size.height + yValue
                    }
                }
                
                // For the fragment in the delegate, activity has been enumrated, and set 'fragmentPosition' for the fragment, append it into 'fragments' lastly.
                fragment?.fragmentPosition = index
                fragments.append(fragment!)
                
            }
            // Append ended, set content size for self.
            let tempMaxHeight: CGFloat = self.frame.height > yValue ? self.frame.height : yValue
            self.contentSize = CGSize(width: self.frame.width,
                                      height: tempMaxHeight)
            
            // If exist the top fragment, and add it into activity.
            if let topFragment = activityDelegate.topFragmentForSGActivity?(self) {
                self.topFragment = topFragment
                if let topFragmentDelegate = topFragment.delegate {
                    for itemIndex in 0..<topFragmentDelegate.numberOfItemForFragment(topFragment) {
                        
                        let subItem = topFragment.delegate?.itemAtIndex(itemIndex, fragment: topFragment)
                        subItem?.frame = CGRect(x: 0,
                                                y: -subItem!.frame.height,
                                                width: subItem!.frame.width,
                                                height: subItem!.frame.height)
                        
                        if subItem!.bundle != nil {
                            subItem!.bindBundle(subItem!.bundle)
                        }
                        
                        self.addSubview(subItem!)
                    }
                }
            }
            
            // If exist the bottom fragment, and add it into activity.
            if let bottomFragment = activityDelegate.bottomFragmentForSGActivity?(self) {
                self.bottomFragment = bottomFragment
                let underYValue: CGFloat = (self.contentSize.height > kSCREEN_HEIGHT) ? self.contentSize.height : kSCREEN_HEIGHT
                if let bottomFragmentDelegate = bottomFragment.delegate {
                    for itemIndex in 0..<bottomFragmentDelegate.numberOfItemForFragment(bottomFragment) {
                        
                        let subItem = bottomFragment.delegate?.itemAtIndex(itemIndex, fragment: bottomFragment)
                        subItem?.frame = CGRect(x: 0,
                                                y: underYValue,
                                                width: subItem!.frame.width,
                                                height: subItem!.frame.height)
                        
                        if subItem!.bundle != nil {
                            subItem!.bindBundle(subItem!.bundle)
                        }
                        
                        self.addSubview(subItem!)
                    }
                }
            }
            
            if let viceFragment = activityDelegate.viceFragmentForSGActivity?(self) {
                self.viceFragment = viceFragment
                self.viceFragment?.items.forEach({ item in
                    item.isHidden = true
                })
            }
            
            if let placeholderFragment = activityDelegate.placeholderFragmentForSGActivity?(self) {
                self.placeholderFragment = placeholderFragment
//                var yValue: CGFloat = 0
//                placeholderFragment.items.forEach { item in
//                    item.frame = CGRect(x: 0, y: yValue, width: item.frame.width, height: item.frame.height)
//                    item.backgroundColor = .red
//                    self.addSubview(item)
//
//                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
//                        item.isHidden = true
//                    }
//
//                    if item.bundle != nil {
//                        item.bindBundle(item.bundle)
//                    }
//
//                    yValue = yValue + item.frame.height
//                }
            }
            
        }
        setRefresh()
    }
    
    private final func setRefresh(){
        if let activityDelegate = self.activityDelegate {
            if let topTitle = activityDelegate.topRefreshAttributedTitleForSGActivity?(self) {
                self.refreshControl = UIRefreshControl()
                self.refreshControl?.attributedTitle = topTitle
                self.refreshControl?.addTarget(self, action: #selector(topRefreshListener), for: .valueChanged)
            }
            if let bottomTitle = activityDelegate.bottomRefreshAttributedTitleForSGActivity?(self) {
                self.bottomRefreshControl = UIRefreshControl()
                var lastY: CGFloat = self.subviews[self.subviews.count - 1].frame.maxY
                lastY = (self.frame.height > lastY) ? self.frame.height : lastY
                lastY = kSCREEN_HEIGHT
                self.bottomRefreshControl!.frame = CGRect(x: 0, y: lastY, width: kSCREEN_WIDTH, height: 80)
                Log.warning("FRAME: \(self.bottomRefreshControl!.frame)")
                self.bottomRefreshControl!.attributedTitle = bottomTitle
                self.bottomRefreshControl!.addTarget(self, action: #selector(bottomRefreshListener), for: .valueChanged)
                self.addSubview(self.bottomRefreshControl!)
            }
        }
    }
    
    @objc private final func topRefreshListener(){
        if let activityDelegate = self.activityDelegate {
            activityDelegate.topRefreshListenerForSGActivity?(self)
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc private final func bottomRefreshListener(){
        if let activityDelegate = self.activityDelegate {
            activityDelegate.bottomRefreshListenerForSGActivity?(self)
            self.bottomRefreshControl?.endRefreshing()
        }
    }
    
}

// MARK: - Outside method.
extension SGActivity{
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    
    // MARK: - Rotate.
    open func activityRotate(rawValue: Int){
        switch rawValue {
        case 1:
            /**
             Likes this mode:
             ┏━━━━━┓
             ┃  ┏━━┓  ┃
             ┃  ┃       ┃  ┃
             ┃  ┃       ┃  ┃
             ┃  ┃       ┃  ┃
             ┃  ┃       ┃  ┃
             ┃  ┗━━┛  ┃
             ┃        o        ┃
             ┗━━━━━┛
             */
            
            var yValue: CGFloat = 0
            
            // Set all items was visiable.
            fragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.isHidden = false
                }
            }
            
            // Hidden the vice fragment.
            if let viceFragment = self.viceFragment {
                viceFragment.items.forEach { item in
                    item.isHidden = true
                }
            }
            
            // Iterate fragment to iterate items.
            fragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.frame = CGRect(x: fragment.sideSpacing / 2,
                                        y: yValue,
                                        width: item.originalWidth - fragment.sideSpacing,
                                        height: item.frame.height)
                    
                    // Sub item frame has been setted, then call the method of 'itemWillRotate'.
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 1)
                    }

                    // When activity execute this case, which means it's not first time to load,
                    // item need to re-bind bundle in this situation consequently.
                    if item.bundle != nil {
                        item.bindBundle(item.bundle)
                    }

                    yValue = item.frame.height + yValue
                }
            }

            UIView.animate(withDuration: 0.382) {
                self.frame = CGRect(x: self.frame.origin.x,
                                    y: self.frame.origin.y,
                                    width: kSCREEN_WIDTH,
                                    height: kSCREEN_HEIGHT)
                let tempMaxHeight: CGFloat = self.frame.height > yValue ? self.frame.height : yValue
                self.contentSize = CGSize(width: self.frame.width, height: tempMaxHeight)
            }
            
            isInPortraitMode = true
            
            if let topFragment = self.topFragment {
                var downYValue: CGFloat = 0
                topFragment.items.forEach { item in
                    downYValue = downYValue - item.frame.height
                    item.frame = CGRect(x: 0,
                                        y: downYValue,
                                        width: item.frame.width,
                                        height: item.frame.height)
                    
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 1)
                    }
                    
                    if item.bundle != nil {
                        item.bindBundle(item.bundle)
                    }
                }
            }
            
            if let bottomFragment = self.bottomFragment {
                var underYValue: CGFloat = (self.contentSize.height > kSCREEN_HEIGHT) ? self.contentSize.height : kSCREEN_HEIGHT
                bottomFragment.items.forEach { item in
                    underYValue = underYValue - item.frame.height
                    item.frame = CGRect(x: 0,
                                        y: underYValue,
                                        width: item.frame.width,
                                        height: item.frame.height)
                    
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 1)
                    }
                    
                    if item.bundle != nil {
                        item.bindBundle(item.bundle)
                    }
                }
                
            }
            
        case 3:
            /**
             Likes this mode:
             ------------------------
             |   -----------------------------------       |
             |   |                                         |  o  |
             |   -----------------------------------       |
             ------------------------
                 -     -
             */
            
            // Set `isActive` attributes.
            
            // Set all items visiable is according to `isActive`.
            fragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.isHidden = (fragment.isActive) ? false : true
                }
            }
            
            let newActiveFragments: Array<SGFragment> = fragments.compactMap { fragment in
                return (fragment.isActive == true) ? fragment : nil
            }
            
            var activeYValue: CGFloat = 0
            newActiveFragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.frame = CGRect(x: fragment.sideSpacing / 2,
                                        y: activeYValue,
                                        width: kSCREEN_HEIGHT - fragment.sideSpacing,
                                        height: item.frame.height)
                    
                    // Sub item frame has been setted, then call the method of 'itemWillRotate'.
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 3)
                    }

                    // When activity execute this case, which means it's not first time to load,
                    // item need to re-bind bundle in this situation consequently.
                    if item.bundle != nil {
                        item.bindBundleLandscape(item.bundle ?? nil)
                    }

                    activeYValue = item.frame.height + activeYValue
                }
            }
            
            if self.isActiveCount >= 1 {
                UIView.animate(withDuration: 0.5) {
                    self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                    self.contentSize = CGSize(width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                }
                return
            }
            
            // Check the vice fragment is exist and iterate the `items` to set a new view in landscape mode.
            if let viceFragment = self.viceFragment {
                // First set the source of `fragments` to be hidden.(for show the vice fragment only)
                fragments.forEach { fragment in
                    fragment.items.forEach { item in
                        item.isHidden = true
                    }
                }
                
                var yValue: CGFloat = 0
                
                // Iterate the vice fragment.
                viceFragment.items.forEach { item in
                    // Set the the property of the `isHidden` for vice fragment's item to be false only.
                    item.isHidden = false
                    item.frame = CGRect(x: viceFragment.sideSpacing / 2,
                                        y: yValue,
                                        width: kSCREEN_HEIGHT - viceFragment.sideSpacing,
                                        height: item.frame.height)
                    
                    if item.superview == nil {
                        self.addSubview(item)
                    }
                    
                    // Sub item frame has been setted, then called the method of 'itemWillRotate'.
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 3)
                    }
                    
                    // When activity execute this case, which means it's not first time to load,
                    // item need to re-bind bundle in this situation consequently.
                    if item.bundle != nil {
                        item.bindBundleLandscape(item.bundle ?? nil)
                    }

                    yValue = item.frame.height + yValue
                }
                
                UIView.animate(withDuration: 0.5) {
                    self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                    self.contentSize = CGSize(width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                }
                
                isInPortraitMode = false
                
                return
            }

            var yValue: CGFloat = 0
            
            // Set all items visiable is according to `isInterest`.
            fragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.isHidden = (fragment.isInterest) ? true : false
                }
            }
            
            // Iterate fragments to iterate items.
            // Filter the frgaments that the property of `isInterest` is false, which is make for hiddeing the fragment.
            let newFragments: Array<SGFragment> = fragments.compactMap { fragment in
                return (fragment.isInterest == false) ? fragment : nil
            }
            newFragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.frame = CGRect(x: fragment.sideSpacing / 2,
                                        y: yValue,
                                        width: kSCREEN_HEIGHT - fragment.sideSpacing,
                                        height: item.frame.height)
                    
                    // Sub item frame has been setted, then call the method of 'itemWillRotate'.
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 3)
                    }

                    // When activity execute this case, which means it's not first time to load,
                    // item need to re-bind bundle in this situation consequently.
                    if item.bundle != nil {
                        item.bindBundleLandscape(item.bundle ?? nil)
                    }

                    yValue = item.frame.height + yValue
                }
            }
            
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                self.contentSize = CGSize(width: kSCREEN_HEIGHT, height: yValue)
            }
            
            isInPortraitMode = false
            
            if let topFragment = self.topFragment {
                var downYValue: CGFloat = 0
                topFragment.items.forEach { item in
                    downYValue = downYValue - item.frame.height
                    item.frame = CGRect(x: 0,
                                        y: downYValue,
                                        width: kSCREEN_HEIGHT,
                                        height: item.frame.height)
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 3)
                    }
                    
                    if item.bundle != nil {
                        item.bindBundle(item.bundle)
                    }
                }
            }
            if let bottomFragment = self.bottomFragment {
                var underYValue: CGFloat = self.contentSize.height
                bottomFragment.items.forEach { item in
                    underYValue = underYValue + item.frame.height
                    item.frame = CGRect(x: 0,
                                        y: underYValue,
                                        width: kSCREEN_HEIGHT,
                                        height: item.frame.height)
                    
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 3)
                    }
                    
                    if item.bundle != nil {
                        item.bindBundle(item.bundle)
                    }
                }
            }
            
        case 4:
            /**
             Likes this mode:
             ------------------------
             |    -----------------------------------      |
             | o |                                         |     |
             |    -----------------------------------      |
             ------------------------
                            -
             */
            // Check the vice fragment is exist and iterate the `items` to set a new view in landscape mode.
            if let viceFragment = self.viceFragment {
                fragments.forEach { fragment in
                    fragment.items.forEach { item in
                        item.isHidden = true
                    }
                }
                
                var yValue: CGFloat = 0
                
                viceFragment.items.forEach { item in
                    item.isHidden = false
                    item.frame = CGRect(x: viceFragment.sideSpacing / 2,
                                        y: yValue,
                                        width: kSCREEN_HEIGHT - viceFragment.sideSpacing,
                                        height: item.frame.height)
                    
                    if item.superview == nil {
                        self.addSubview(item)
                    }
                    
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 4)
                    }

                    // When activity execute this case, which means it's not first time to load,
                    // item need to re-bind bundle in this situation consequently.
                    if item.bundle != nil {
                        item.bindBundleLandscape(item.bundle ?? nil)
                    }

                    yValue = item.frame.height + yValue
                }
                
                UIView.animate(withDuration: 0.5) {
                    self.frame = CGRect(x: 0, y: self.frame.origin.y, width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                    self.contentSize = CGSize(width: kSCREEN_HEIGHT, height: yValue)
                }
                
                isInPortraitMode = false
                
                return
            }
            
            var yValue: CGFloat = 0
            
            // Set all items visiable is according to `isInterest`.
            fragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.isHidden = (fragment.isInterest) ? true : false
                }
            }
            
            // Iterate fragment to iterate items.
            let newFragments: Array<SGFragment> = fragments.compactMap { fragment in
                return (fragment.isInterest == false) ? fragment : nil
            }
            newFragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.frame = CGRect(x: fragment.sideSpacing / 2,
                                        y: yValue,
                                        width: kSCREEN_HEIGHT - fragment.sideSpacing,
                                        height: item.frame.height)
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 4)
                    }

                    item.bindBundleLandscape(item.bundle ?? nil)

                    yValue = item.frame.height + yValue
                }
            }

            UIView.animate(withDuration: 0.382) {
                self.frame = CGRect(x: 0, y: 44, width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                self.contentSize = CGSize(width: kSCREEN_HEIGHT, height: yValue)
            }
            
            isInPortraitMode = false
            
            if let topFragment = self.topFragment {
                var underYValue: CGFloat = 0
                topFragment.items.forEach { item in
                    underYValue = underYValue - item.frame.height
                    item.frame = CGRect(x: 0,
                                        y: underYValue,
                                        width: kSCREEN_HEIGHT,
                                        height: item.frame.height)
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 3)
                    }
                    
                    if item.bundle != nil {
                        item.bindBundle(item.bundle)
                    }
                }
            }
            if let bottomFragment = self.bottomFragment {
                var underYValue: CGFloat = self.contentSize.height
                bottomFragment.items.forEach { item in
                    underYValue = underYValue + item.frame.height
                    item.frame = CGRect(x: 0,
                                        y: underYValue,
                                        width: kSCREEN_HEIGHT,
                                        height: item.frame.height)
                    
                    UIView.animate(withDuration: 0.382) {
                        item.itemWillRotate(rawValue: 3)
                    }
                    
                    if item.bundle != nil {
                        item.bindBundle(item.bundle)
                    }
                }
            }
            
        default:
            break
        }
    }
    
    // MARK: - Mount life cycle.
    
    /**
     Mount to ViewController to execute this method, this method will called fragment's mount life cycle method.
     */
    @objc public final func activityDidLoad(){
        if let activityDelegate = self.activityDelegate{
            activityDelegate.activityDidLoad?()
            for index in 0..<activityDelegate.numberOfSGFragmentForSGActivity(self) {
                let fragment = activityDelegate.fragmentAtIndex?(self, index: index)
                fragment?.fragmentDidLoad()
            }
        }
    }
    /**
     Mount to ViewController to execute this method, this method will called fragment's mount life cycle method.
     */
    @objc public final func activityWillAppear(){
        if let activityDelegate = self.activityDelegate{
            activityDelegate.activityWillAppear?()
            for index in 0..<activityDelegate.numberOfSGFragmentForSGActivity(self) {
                let fragment = activityDelegate.fragmentAtIndex?(self, index: index)
                fragment?.fragmentWillAppear()
            }
        }
    }
    /**
     Mount to ViewController to execute this method, this method will called fragment's mount life cycle method.
     */
    @objc final func activityDidAppear(){
        if let activityDelegate = self.activityDelegate{
            activityDelegate.activityDidAppear?()
            for index in 0..<activityDelegate.numberOfSGFragmentForSGActivity(self) {
                let fragment = activityDelegate.fragmentAtIndex?(self, index: index)
                fragment?.fragmentDidAppear()
            }
        }
    }
    /**
     Mount to ViewController to execute this method, this method will called fragment's mount life cycle method.
     */
    @objc final func activityWillDisappear(){
        if let activityDelegate = self.activityDelegate{
            activityDelegate.activityWillDisappear?()
            for index in 0..<activityDelegate.numberOfSGFragmentForSGActivity(self) {
                let fragment = activityDelegate.fragmentAtIndex?(self, index: index)
                fragment?.fragmentWillDisappear()
            }
        }
    }
    /**
     Mount to ViewController to execute this method, this method will called fragment's mount life cycle method.
     */
    @objc final func activityDidDisappear(){
        if let activityDelegate = self.activityDelegate{
            activityDelegate.activityDidDisappear?()
            for index in 0..<activityDelegate.numberOfSGFragmentForSGActivity(self) {
                let fragment = activityDelegate.fragmentAtIndex?(self, index: index)
                fragment?.fragmentDidDisappear()
            }
        }
    }
    
    // MARK: - Add, Delete, Update, Get.
    
    /**
     Return a fragment.
     */
    open func getFragment(at index: Int) -> SGFragment{
        return fragments[index]
    }
    
    /**
     Add a fragment by specify index.
     - Parameter element: SGFragment instance, it must be a full instance object.
     - Parameter index: Index.
     */
    open func addFragment(_ element: SGFragment, after index: Int){
        // First we ought to set the fragment that the 'fragmentPosition' was bigger than index, and increasednby 1,
        // and set the element(fragment) 'fragmentPosition' with index, which could ensure the new 'fragments' was a correctly index collection.
        // Then we add the subItem where located in element(fragment) into self.
        // Last we reset the frame of subItem where the its parent fragment's 'fragmentPosition' was bigger than index.
        
        // Reset the position for 'fragments'.
        fragments.forEach { fragment in
            // The fragment position of the fragment after the parameter "index" should be increased by 1.
            if fragment.fragmentPosition >= index {
                fragment.fragmentPosition = fragment.fragmentPosition + 1
            }
        }
        
        // Then insert the element into 'fragments', set its 'fragmentPosition' with index.
        fragments.insert(element, at: index)
        element.fragmentPosition = index

        // Iterate the items of the fragment located at the index position in the 'fragments' and put them into 'items'.
        fragments.forEach { fragment in
            if fragment.fragmentPosition == index{
                fragment.items.forEach { item in
                    self.addSubview(item)
                    item.alpha = 0
                    UIView.animate(withDuration: 0.618) {
                        item.alpha = 1
                    }
                }
            }
        }
        
        // Find the maximum subitem height and y value in the previous fragment of the index of the modified 'fragments'.
        var maxYValue: CGFloat = 0
        var maxViewHeight: CGFloat = 0
        fragments.forEach { fragment in
            if fragment.fragmentPosition == (index - 1){
                fragment.items.forEach { item in
                    if item.frame.origin.y >= maxYValue {
                        maxYValue = item.frame.origin.y
                        maxViewHeight = maxYValue + item.frame.size.height
                    }
                }
            }
        }

        // Update the items's frame of all frames after the index in the 'fragments'.
        var currentYValue: CGFloat = maxViewHeight
        fragments.forEach { fragment in
            if fragment.fragmentPosition >= index {
                fragment.items.forEach { item in
                    UIView.animate(withDuration: 0.618, delay: 0, usingSpringWithDamping: 0.618, initialSpringVelocity: 0.382, options: .curveEaseInOut) {
                        item.frame = CGRect(x: item.frame.origin.x,
                                            y: currentYValue,
                                            width: item.frame.size.width,
                                            height: item.frame.size.height)
                    } completion: { (true) in
                        
                    }
                    currentYValue = currentYValue + item.frame.height
                }
            }
        }
        
        // Update content size.
        self.contentSize = CGSize(width: self.frame.width, height: currentYValue)
        
        if let activityDelegate = self.activityDelegate {
            // If exist the bottom fragment, and update its frame.
            if let bottomFragment = activityDelegate.bottomFragmentForSGActivity?(self) {
                let subItem = bottomFragment.delegate?.itemAtIndex(0, fragment: bottomFragment)
                subItem?.frame = CGRect(x: 0,
                                        y: self.contentSize.height + 100,
                                        width: subItem!.frame.width,
                                        height: subItem!.frame.height)
                if subItem!.bundle != nil {
                    subItem!.bindBundle(subItem!.bundle)
                }
            }
        }
    }
    
    /**
     Delete a fragment by index.
     */
    open func deleteFragment(at index: Int){
        fragments.forEach { fragment in
            if fragment.fragmentPosition == index{
                fragment.items.forEach { item in
                    UIView.animate(withDuration: 0.618, delay: 0, usingSpringWithDamping: 0.618, initialSpringVelocity: 0.382, options: .curveEaseInOut) {
                        item.alpha = 0
                    } completion: { (true) in
                        item.removeFromSuperview()
                    }
                }
            }
        }
        
        fragments.forEach { fragment in
            if fragment.fragmentPosition >= index {
                fragment.fragmentPosition = fragment.fragmentPosition - 1
            }
        }
        
        fragments.remove(at: index)
        
        // Find the maximum subitem height and y value in the previous fragment of the index of the modified 'fragments'.
        var maxYValue: CGFloat = 0
        var maxViewHeight: CGFloat = 0
        fragments.forEach { fragment in
            if fragment.fragmentPosition == (index - 1){
                fragment.items.forEach { item in
                    if item.frame.origin.y >= maxYValue {
                        maxYValue = item.frame.origin.y
                        maxViewHeight = maxYValue + item.frame.size.height
                    }
                }
            }
        }
        // Update the items's frame of all frames after the index in the 'fragments'.
        var currentYValue: CGFloat = maxViewHeight
        fragments.forEach { fragment in
            if fragment.fragmentPosition >= index {
                fragment.items.forEach { item in
                    item.alpha = 0
                    UIView.animate(withDuration: 0.618, delay: 0, usingSpringWithDamping: 0.618, initialSpringVelocity: 0.382, options: .curveEaseInOut) {
                        item.frame = CGRect(x: item.frame.origin.x,
                                            y: currentYValue,
                                            width: item.frame.size.width,
                                            height: item.frame.size.height)
                        item.alpha = 1
                    } completion: { (true) in
                        
                    }
                    currentYValue = currentYValue + item.frame.size.height
                }
            }
        }
        
        // Update content size.
        self.contentSize = CGSize(width: self.frame.width, height: currentYValue)
    }
    
    /**
     According to specify index to get a fragment and operate it.
     - Parameter index: Fragment index.
     - Parameter completion: Operation completion handler.
     - Returns: SGFragment, and may the result will not be useful.
     */
    @discardableResult
    open func updateFragment(at index: Int, completion: ((_ fragment: SGFragment) -> SGFragment)?) -> SGFragment{
        fragments[index] = completion!(fragments[index])
        return fragments[index]
    }
    
    // MARK: - Others method.
    /**
     
     */
    open func setEnablePlaceholderFragment(){
        if let activityDelegate = self.activityDelegate {
            for index in 0..<activityDelegate.numberOfSGFragmentForSGActivity(self) {
                // Get outmost layer framgent by index.
                let fragment = activityDelegate.fragmentAtIndex?(self, index: index)
                if let fragmentDelegate = fragment?.delegate {
                    
                    // Enumerated current fragment to get sub item.
                    for itemIndex in 0..<fragmentDelegate.numberOfItemForFragment(fragment!) {
                        
                        // Get current fragment's sub item by index.
                        let subItem = fragmentDelegate.itemAtIndex(itemIndex, fragment: fragment!)
                        
                        // Set animated for fragment which was located in here.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut) {
                                subItem.alpha = 0
                            } completion: { (true) in
                                subItem.isHidden = true
                            }
                        }
                    }
                }
            }
        }
        
        if let placeholderFragment = self.placeholderFragment {
            var yValue: CGFloat = 0
            placeholderFragment.items.forEach { item in
                item.frame = CGRect(x: 0, y: yValue, width: item.frame.width, height: item.frame.height)
                self.addSubview(item)
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                    item.isHidden = false
                }
                
                if item.bundle != nil {
                    item.bindBundle(item.bundle)
                }
                
                yValue = yValue + item.frame.height
            }
        }
        
        
    }
    
    /**
     
     */
    open func setDisablePlaceholderFragment(){
        fragments.forEach { fragment in
            fragment.items.forEach { item in
                item.isHidden = false
                item.alpha = 0
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                    item.alpha = 1
                } completion: { (true) in
                }
            }
        }
        if let placeholderFragment = activityDelegate?.placeholderFragmentForSGActivity?(self) {
            placeholderFragment.items.forEach { item in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                    item.alpha = 1
                    item.isHidden = true
                } completion: { (true) in
                    if item.superview != nil {
                        item.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    /**
     Scroll to specified SGItem.
     - Parameter index: The index of item in totally.
     */
    open func jumpTo(atItem index: Int, _ animated: Bool = true){
        assert(index <= items.count, "SGActivity can not jump to over the range of index position.")
        
        let rect: CGRect = CGRect(x: self.frame.origin.x,
                                  y: items[index].frame.origin.y,
                                  width: self.frame.size.width,
                                  height: self.frame.size.height)
        
        self.scrollRectToVisible(rect, animated: animated)
        
    }
    
    /**
     Scroll to specified SGFragment.
     - Parameter index: The index of fragment in totally, it containes convenience fragments but except for Top or Bottom fragment.
     */
    open func jumpTo(atFragment index: Int, _ animated: Bool = true){
        assert(index <= fragments.count, "SGActivity can not jump to over the range of index position.")
        
        let rect = CGRect(x: self.frame.origin.x,
                          y: fragments[index].items[0].frame.origin.y,
                          width: self.frame.size.width,
                          height: self.frame.size.height)
        
        self.scrollRectToVisible(rect, animated: animated)
    }
    
    /**
     Call this method to jump to the top edge.
     */
    open func jumpToTop(_ animated: Bool = true){
        self.scrollRectToVisible(CGRect(x: self.frame.origin.x,
                                        y: 0,
                                        width: self.frame.size.width,
                                        height: self.frame.size.height), animated: animated)
    }
    
    /**
     Call this method to jump to the bottom edge.
     */
    open func jumpToBottom(_ animated: Bool = true){
        // Scroll distance can not be the max y of content size, decrease 1 for itself is the best way to solve it consequently.
        let distance: CGFloat = self.contentSize.height - 1
        self.scrollRectToVisible(CGRect(x: self.frame.origin.x,
                                        y: distance,
                                        width: self.frame.size.width,
                                        height: self.frame.size.height), animated: animated)
    }
    
    /**
     Call this method, the activity will refresh the content totally, all the override delegates will be executed again.
     */
    open func setForceRefresh(){
        _reload()
        setNeedsLayout()
    }
    
    /**
     Reload `bindBundle()` method.
     */
    open func setReloadData(){
        items.forEach { item in
            if item.bundle != nil {
                if isInPortraitMode {
                    // Execute portrait refresh strategy.
                    item.bindBundle(item.bundle)
                } else{
                    // Execute landscape refresh strategy.
                    item.bindBundleLandscape(item.bundle)
                }
            }
        }
    }
    
}
