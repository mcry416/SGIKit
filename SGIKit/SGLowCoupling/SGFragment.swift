//
//  SGFragment.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/16.
//

import UIKit

/**
 A fragment originized form  that manage sub item for SGActivity.
 SGFragment manages sub item layout, side spacing, update and animation, and so on.
 - Example code:
 ```
 class Top1Fragment: SGFragment, SGFragmentDelegate{

     override init() {
         super.init()
         
         self.animatedInterval = 1
         
         let top1 = Top1Item()
         top1.size = CGSize(width: kSCREEN_WIDTH, height: 166)
         
         items.append(top1)
         
         self.delegate = self
     }
     
     func numberOfItemForFragment(_ fragment: SGFragment) -> Int {
         return items.count
     }
     
     func itemAtIndex(_ index: Int, fragment: SGFragment) -> SGItem {
         return items[index]
     }
     
 }

 ```
 - Originized form.
 
 As you can see, create a class that inherited from SGFragment and implements reqiured method, it's a basic frgament.
 
 - Note: The SGFragment whose `isActive` attribute is true has the highest priority in the architecture,  the vice-SGFragment(If the delegate is non-nil)is less than above.
 And the source of `fragments` take the next place(The attribute of `isInterest` will action in this mode), last the lowest priority is bottom and top SGFragment(If the delegate is non-nil).
 */
class SGFragment: NSObject{
    
    public weak var delegate: SGFragmentDelegate?
    
    /// SGFragment sub items cache.
    public var items: Array<SGItem> = Array<SGItem>()
    
    /// SGFragment position that arranged in activity.
    public var fragmentPosition: Int = 0
    
    /// Item right and left spacing, default 0.
    public var sideSpacing: CGFloat = 0
    
    /// Item animated interval , default 0.382.
    public var animatedInterval: TimeInterval = 0.382
    
    /// Indicate the fragment is be interested in roate mode for SGActivity, and value is true means the fragment will faded. Defalut is `false`.
    public var isInterest: Bool = false
    
    /// Indicate the fragment is be actived in rotated mode for SGActivity, and value is true means the fragment will keep the life cycle and outlooks as the same. Defalut is  `false`.
    public var isActive: Bool = false
    
    /// When SGFragment was instanced to use this closure.
    private var loadedCompletionClosure: ((_ items: Array<SGItem>) -> Void)?
    
    /// When items was binded to use this closure.
    private var bindCompletionClosure: ((_ item: SGItem, _ bundle: Any, _ index: Int) -> Void)?
    
}

// MARK: - Outside method.
extension SGFragment{
    
    /**
     When items was iterated and executed this method.
     - Parameter handler: Process handler, to do business.
     */
    public final func bindCompletionHandler(_ handler: ((_ item: SGItem, _ bundle: Any, _ index: Int) -> Void)?){
        bindCompletionClosure = { (item, bundles, index) in
            handler!(item, bundles, index)
        }
    }
    
    /**
     When SGFragment was instanced and executed this method.
      - Parameter handler: Process handler, to do business.
     */
    public final func loadedCompletionHandler(_ handler: ((_ items: Array<SGItem>) -> Void)?){
        loadedCompletionClosure = { (items) in
            handler!(items)
        }
    }
    
    /**
     When device was rotated and overrided this method to process the condition of rotated.
     - Parameter rawValue: Spin code, 0 meas normally, 1 means device back, 2 means volume button at the bottom, 3 means power button at the bottom.
     */
    @objc open func fragmentWillRotate(rawValue: Int){
        
    }
    
    /**
     When fragment did load at activity and this method will be called. Override the method to get callback method.
     */
    @objc open func fragmentDidLoad(){
        
    }
    
    /**
     When fragment will appear at activity and this method will be called. Override the method to get callback method.
     */
    @objc open func fragmentWillAppear(){
        
    }
    
    /**
     When fragment did appear at activity and this method will be called. Override the method to get callback method.
     */
    @objc open func fragmentDidAppear(){
        
    }
    
    /**
     When fragment will disappear at activity and this method will be called. Override the method to get callback method.
     */
    @objc open func fragmentWillDisappear(){
        
    }
    
    /**
     When fragment did disappear at activity and this method will be called. Override the method to get callback method.
     */
    @objc open func fragmentDidDisappear(){
        
    }
    
    /**
     When user updated the item bundle, call this method to update the UI, and this method run in the main thread default.
     */
    public final func fragmentRefresh(){
        DispatchQueue.main.async {
            var iterateIndex: Int = 0
            self.items.forEach { item in
                iterateIndex = iterateIndex + 1
                if item.bundle != nil {
                    // Force the bundle convert to NSObject type, so that we could use the property '.hashValue'.
                    let hashBundle = item.bundle as! NSObject
                    
                    // Update the item that bundle was changed only.
                    // 'SGItem.bundleHashValue' is a special queue type that its capacity is 2.
                    // When the 'bundleHashValue' is 0, which means it has not been initlized,
                    // When the 'bundleHashValue' is 1, which means it has been initlized and just one times,
                    // When the 'bundleHashValue' is 2, which means it may be updated the bundle one or more times.
                    // So we just need to update the item that its bundle was changed one or more times, which is a effective way to update.
                    if item.bundleHashValue.peek() != hashBundle.hashValue {
                        item.bindBundle(item.bundle)
                    }
                }
            }
        }
    }

}
