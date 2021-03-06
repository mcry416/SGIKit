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
    
    enum Direction {
        case vertical
        case horizontal
    }
    
    /// Delegate for SGActivity.
    public var activityDelegate: SGActivityDelegate?
    
    /// Inside fragments collection, which contains organizational form for SGItem.
    public var fragments: Array<SGFragment> = Array<SGFragment>()
    
    /// Inside items collection.
    public var items: Array<SGItem> = Array<SGItem>()
    
    /// SGItem organizational forms.
    private var direction: Direction = .vertical
    
    /// The activity whether in portrait model.
    private var isInPortraitModel: Bool = true
    
    public var isScrollToTopTouchOff: Bool = false
    
    /// When device was rotated called this method
    public var activityWillRotate: ((_ rawValue: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _initView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {

        _reload()
        
    }
    
}

// MARK: - Init.
extension SGActivity{
    
    fileprivate final func _initView(){
        // Delegate for SGActivityRefresh.
        self.delegate = self
    }
    
    // MARK: - Reload.
    fileprivate final func _reload(){
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
                let sideSpacing: CGFloat = fragment?.sideSpacing ?? 0
                if let fragmentDelegate = fragment?.delegate {
                    
                    // Enmerated current fragment to get sub item.
                    for itemIndex in 0..<fragmentDelegate.numberOfItemForFragment(fragment!) {
                        
                        // Get current fragment's sub item by index.
                        let subItem = fragmentDelegate.itemAtIndex(itemIndex, fragment: fragment!)
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
            self.contentSize = CGSize(width: self.frame.width,
                                      height: yValue)
            
            // If exist the top fragment, and add it into activity.
            if let topFragment = activityDelegate.topFragmentForSGActivity?(self) {
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
                if let bottomFragmentDelegate = bottomFragment.delegate {
                    for itemIndex in 0..<bottomFragmentDelegate.numberOfItemForFragment(bottomFragment) {
                        
                        let subItem = bottomFragment.delegate?.itemAtIndex(itemIndex, fragment: bottomFragment)
                        subItem?.frame = CGRect(x: 0,
                                                y: self.contentSize.height,
                                                width: subItem!.frame.width,
                                                height: subItem!.frame.height)
                        
                        if subItem!.bundle != nil {
                            subItem!.bindBundle(subItem!.bundle)
                        }
                        
                        self.addSubview(subItem!)
                    }
                }
            }
            
        }
        
    }
    
}

// MARK: - Outside method.
extension SGActivity{
    
    // MARK: - Rotate.
    open func activityRotate(rawValue: Int){
        switch rawValue {
        case 1:
            /**
             Likes this mode:
             ---------
             |   -----------   |
             |   |            |  |
             |   |            |  |
             |   |            |  |
             |   -----------   |
             |        o         |
             ---------
             */
            var yValue: CGFloat = 0
            // Iterate fragment to iterate items.
            fragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.frame = CGRect(x: fragment.sideSpacing / 2,
                                        y: yValue,
                                        width: item.frame.width,
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
                self.contentSize = CGSize(width: self.frame.width, height: yValue)
            }
            
            isInPortraitModel = true
            
            if let topFragment = activityDelegate?.topFragmentForSGActivity?(self) {
                var underYValue: CGFloat = 0
                topFragment.items.forEach { item in
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
            var yValue: CGFloat = 0
            for subItem in self.items {
                subItem.frame = CGRect(x: 0,
                                       y: yValue,
                                       width: kSCREEN_HEIGHT,
                                       height: subItem.frame.height)
                UIView.animate(withDuration: 0.5) {
                    subItem.itemWillRotate(rawValue: 3)
                }
      //          subItem.itemWillRotate(rawValue: 3)
                yValue  = subItem.frame.height + yValue
            }
            
            if activityWillRotate != nil {
                activityWillRotate!(3)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: 0, y: 44, width: kSCREEN_HEIGHT, height: kSCREEN_WIDTH)
                self.contentSize = CGSize(width: kSCREEN_HEIGHT, height: yValue)
            }
            
            isInPortraitModel = false
            
            if let topFragment = activityDelegate?.topFragmentForSGActivity?(self) {
                var underYValue: CGFloat = 0
                topFragment.items.forEach { item in
                    underYValue = underYValue - item.frame.height
                    item.frame = CGRect(x: 0,
                                        y: underYValue,
                                        width: self.contentSize.width,
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
            var yValue: CGFloat = 0
            fragments.forEach { fragment in
                fragment.items.forEach { item in
                    item.frame = CGRect(x: fragment.landscapeSideSpacing / 2,
                                        y: yValue,
                                        width: kSCREEN_HEIGHT - fragment.landscapeSideSpacing,
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
            
            isInPortraitModel = false
            break
        default:
            break
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
                if isInPortraitModel {
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
