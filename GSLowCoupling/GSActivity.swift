/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

/**
 `SGActivityView` controller layer and Fragment loaded layer(aka `ViewModel`), which should be setted before the `SGActivityView` move to superview. And when it was setted, the method of `onActivityLoad()` will be executed.
 */
open class GSActivity: NSObject, UIScrollViewDelegate {
    
    /** Data source for `SGItem`.  Operating it just in initlized, do not operate this property anytime. */
    public var items: Array<GSItem> = { Array<GSItem>() }()
    
    /** Indicate the activity should to rotated. */
    public var isEnableRotated: Bool = true
    
    /** Indicate the activity should to rotated changed its frame automatically. */
    public var isAutoRotatedSelf: Bool = true
    
    /** Indicate the `GSActivity` whether to repeat the method of `override func didMoveToWindow()` again while the current viewController was push/present or pop/dismiss by navigation stack. Default is `false`. */
    public var isEnableAvoidOverWindowRefresh: Bool = false
    
    /** The final container for`SGActivityView` */
    public var responder: UIViewController?
    
    /** The context in the top of `UIWindow`. */
    public weak var context: UIViewController?
    
    internal var isRefreshed: Bool = false
    
    internal var activtyUpdateBlock: (() -> Void)?

    internal var addItemBlock: ((GSItem, Int, Bool) -> Void)?

    internal var removeItemBlock: ((Int, Bool) -> Void)?

    internal var exchangeItemBlock: ((Int, Int, Bool) -> Void)?

    internal var replaceItemBlock: ((GSItem, Int, Bool) -> Void)?

    /**
     Add a specific item to the activity.
     - Parameter item: The item that needed to added.
     - Parameter index: Add index, type of Int.
     - Parameter animated: Animation that the item whether to presented.
     */
    public final func addItem(_ item: GSItem, at index: Int, animated: Bool = true) {
        addItemBlock?(item, index, animated)
    }

    /**
     Remove a specific item from the activity.
     - Parameter index: Remove index, type of Int.
     - Parameter animated: Animation that the item whether to removed.
     */
    public final func removeItem(at index: Int, animated: Bool = true) {
        removeItemBlock?(index, animated)
    }

    public final func exchangeItem(from: Int, to: Int, animated: Bool = true) {
        removeItem(at: from, animated: animated)
        removeItem(at: to, animated: animated)
        addItem(self.items[from], at: to, animated: animated)
        addItem(self.items[to], at: from, animated: animated)
    }

    /**
     Replace a specific item to specific index position.
     - Parameter item: The item that needed to repalced.
     - Parameter index: Replace index, type of Int.
     - Parameter animated: Animation that the item whether to replaced.
     */
    public final func replaceItem(_ item: GSItem, to: Int, animated: Bool = true) {
        removeItem(at: to, animated: animated)
        addItem(item, at: to, animated: animated)
    }

    /** Called this method to update all fragments, in fact, this operation will execute the method of `bindBundle()` finally. */
    public final func update() {
        items.forEach { item in
            item.bundle?.isNeedUpdate = true
        }
        activtyUpdateBlock?()
    }
    
}

extension GSActivity {
    
    /** Top item that beyond the container. */
    @objc open func topItemForSGActivity() -> GSItem? {
        nil
    }
    
    /** Bottom item that beyond the container. */
    @objc open func bottomItemForSGActivity() -> GSItem? {
        nil
    }
    
    /** Placeholder item for the activity. */
    @objc open func placeholderItemForSGActivity() -> GSItem? {
        nil
    }
    
    /** Override this method and return an NSAttributedString to implements slide refresh function. */
    @objc open func topRefreshAttributedTitleForSGActivity() -> NSAttributedString? {
        nil
    }
    
    /** When the container was slided down, and the method will be callbacked. */
    @objc open func topRefreshListenerForSGActivity() {
        
    }
    
    /** After the `SGActivity` initlized it will executed this lifecycle method. */
    @objc open func onActivityLoad() {
        
    }
    
    @objc open func onActivityLoaded() {
        
    }

    /** Moutainer lifecycle of `viewDidLoad()`. */
    @objc open func contextDidLoad() {
        
    }
    
    /** Moutainer lifecycle of `viewWillAppear()`. */
    @objc open func contextWillAppear() {
        
    }
    
    /** Moutainer lifecycle of `viewDidAppear()`. */
    @objc open func contextDidAppear() {
        
    }
    
    /** Moutainer lifecycle of `viewWillDisappear()`. */
    @objc open func contextWillDisappear() {
        
    }
    
    /** Moutainer lifecycle of `viewDidDisappear()`. */
    @objc open func contextDidDisappear() {
        
    }
}
