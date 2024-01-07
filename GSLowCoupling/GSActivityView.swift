/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

/**
 SGLowCoupling container.
 - Note: Before the container was added into superview, setted the acitvity to it immediately.
 */
open class GSActivityView: UIScrollView, UIScrollViewDelegate {
    
    /**
     `SGActivityView` controller layer and Fragment loaded layer(aka `ViewModel`), which should be setted before the `SGActivityView` move to superview.
     And when it was setted, the method of `onActivityLoaded` will be executed.
     */
    open var activity: GSActivity? {
        didSet {
            activity?.onActivityLoad()
        }
    }
    
    open override func didMoveToWindow() {
        guard self.superview != nil else { return }

        if (activity?.isEnableAvoidOverWindowRefresh ?? false) && (activity?.isRefreshed ?? false) {
            return
        }
        // Loaded fragments
        reload()
        // Set the current view's context
        setResponder()
        // Set scroll delegate for self.
        self.delegate = activity
        
        activity?.onActivityLoaded()
        activity?.isRefreshed = true
    }

}

// MARK: - Fragemnt load.
extension GSActivityView {
    
    private func reload() {
        guard let activity = self.activity else { return }
        
        setActionBlocks(activity)
        setBasicItems(activity)
        setExtraItems(activity)
    }
    
    private func setBasicItems(_ activity: GSActivity) {
        let isInPortrait: Bool = (self.frame.width <= UIScreen.main.bounds.width)
        
        var yValue: CGFloat = 0
        let itemCount: Int = activity.items.count
        for index in 0..<itemCount {
            
            // Enumerating the item and ensuring itself ought to present in the corresponding mode.
            let item: GSItem = activity.items[index]
            guard let bundle = item.bundle else {
                fatalError("SGItem must be initlized with a bundle object!")
            }
            if !bundle.isEffectiveInPortrait && isInPortrait {
                continue
            }
            if !bundle.isEffectiveInLandscape && !isInPortrait {
                continue
            }
            
            bundle.bundleWidth = self.frame.width
            bundle.onCreate()
            bundle.bundleUpdateBlock = { [weak self] in
                guard let `self` = self else { return }
                item.alpha = 0.7
                UIView.animate(withDuration: 0.328) {
                    item.alpha = 1
                }
                item.bindBundle(bundle)
                bundle.isNeedUpdate = false

                // When a bundle was update its `bundleHeight`, and the hole items need to update its frames.
                var insideYValue: CGFloat = 0
                activity.items.forEach { item in
                    guard let insideBundle = item.bundle else {
                        fatalError("SGItem must be initlized with a bundle object!")
                    }
                    item.frame = CGRect(x: 0, y: insideYValue, width: insideBundle.bundleWidth, height: insideBundle.bundleHeight)
                    insideYValue = insideYValue + insideBundle.bundleHeight
                }
                self.contentSize = CGSize(width: self.frame.width, height: insideYValue)
            }
            
            let itemBounds: CGRect = CGRect(origin: .zero, size: CGSize(width: bundle.bundleWidth, height: bundle.bundleHeight))

            // Loaded subviews from this callback method.
            item.onItemLoad(frame: itemBounds)
            item.frame = CGRect(x: 0, y: yValue, width: bundle.bundleWidth, height: bundle.bundleHeight)
            item.bindBundle(bundle)
            
            yValue = yValue + bundle.bundleHeight
            
            self.addSubview(item)
            
            // Set animated for fragment which was located in here.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                item.alpha = 0.7
                UIView.animate(withDuration: bundle.animatedInterval) {
                    item.alpha = 1
                }
            }
        }
        
        // Append ended, set content size for self.
        let tempMaxHeight: CGFloat = self.frame.height > yValue ? self.frame.height : yValue
        self.contentSize = CGSize(width: self.frame.width, height: tempMaxHeight)
    }
    
    private func setExtraItems(_ activity: GSActivity) {
        
        // Top item.
        if let item = activity.topItemForSGActivity() {
            guard let bundle = item.bundle else {
                fatalError("SGItem must be initlized with a bundle object!")
            }

            bundle.bundleWidth = self.frame.width
            bundle.onCreate()

            let itemBounds: CGRect = CGRect(origin: .zero, size: CGSize(width: bundle.bundleWidth, height: bundle.bundleHeight))

            item.onItemLoad(frame: itemBounds)
            item.frame = CGRect(x: 0, y: -bundle.bundleHeight, width: bundle.bundleWidth, height: bundle.bundleHeight)
            item.bindBundle(bundle)
            
            // Set animated for fragment which was located in here.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                item.alpha = 0.7
                UIView.animate(withDuration: bundle.animatedInterval) {
                    item.alpha = 1
                }
            }
            
            self.addSubview(item)
        }
        
        // Bottom item.
        if let item = activity.bottomItemForSGActivity() {
            guard let bundle = item.bundle else {
                fatalError("SGItem must be initlized with a bundle object!")
            }
            
            bundle.bundleWidth = self.frame.width
            bundle.onCreate()

            let itemBounds: CGRect = CGRect(origin: .zero, size: CGSize(width: bundle.bundleWidth, height: bundle.bundleHeight))

            item.onItemLoad(frame: itemBounds)
            item.frame = CGRect(x: 0, y: self.frame.maxY, width: bundle.bundleWidth, height: bundle.bundleHeight)
            item.bindBundle(bundle)
            
            // Set animated for fragment which was located in here.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                item.alpha = 0.7
                UIView.animate(withDuration: bundle.animatedInterval) {
                    item.alpha = 1
                }
            }
            
            self.addSubview(item)
        }
        
        // Top refresh area.
        if let topTitle = activity.topRefreshAttributedTitleForSGActivity() {
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.attributedTitle = topTitle
            self.refreshControl?.addTarget(self, action: #selector(topRefreshListener), for: .valueChanged)
        }
    }
    
    @objc private final func topRefreshListener() {
        guard let activity = self.activity else { return }
        activity.topRefreshListenerForSGActivity()
        self.refreshControl?.endRefreshing()
    }
    
    private func setActionBlocks(_ activity: GSActivity) {
        let isInPortrait: Bool = (self.frame.width <= UIScreen.main.bounds.width)
        
        activity.activtyUpdateBlock = {
            activity.items.forEach { item in
                guard let bundle: GSBundle = item.bundle else {
                    fatalError("The property of SGItem instance object's bundle can not be nil!")
                }
                if bundle.isNeedUpdate {
                    item.bindBundle(bundle)
                    bundle.isNeedUpdate = false
                    
                    var insideYValue: CGFloat = 0
                    activity.items.forEach { item in
                        guard let insideBundle = item.bundle else {
                            fatalError("SGItem must be initlized with a bundle object!")
                        }
                        item.frame = CGRect(x: 0, y: insideYValue, width: insideBundle.bundleWidth, height: insideBundle.bundleHeight)
                        insideYValue = insideYValue + insideBundle.bundleHeight
                    }
                    self.contentSize = CGSize(width: self.frame.width, height: insideYValue)
                }
            }
        }
        
        activity.addItemBlock = { [weak self] (item, index, animted) in
            guard let `self` = self else { return }
            var lastItemY: CGFloat = 0
            if index > 0 {
                lastItemY = activity.items[index - 1].frame.maxY
            }
            activity.items.insert(item, at: index)

            guard let bundle = item.bundle else {
                fatalError("SGItem must be initlized with a bundle object!")
            }
            if !bundle.isEffectiveInPortrait && isInPortrait {
                return
            }
            if !bundle.isEffectiveInLandscape && !isInPortrait {
                return
            }
            
            bundle.bundleWidth = self.frame.width
            bundle.onCreate()
            bundle.bundleUpdateBlock = { [weak self] in
                guard let `self` = self else { return }
                item.bindBundle(bundle)
                bundle.isNeedUpdate = false

                // When a bundle was update its `bundleHeight`, and the hole items need to update its frames.
                var insideYValue: CGFloat = 0
                activity.items.forEach { item in
                    guard let insideBundle = item.bundle else {
                        fatalError("SGItem must be initlized with a bundle object!")
                    }
                    item.frame = CGRect(x: 0, y: insideYValue, width: insideBundle.bundleWidth, height: insideBundle.bundleHeight)
                    insideYValue = insideYValue + insideBundle.bundleHeight
                }
                self.contentSize = CGSize(width: self.frame.width, height: insideYValue)
            }
            
            let itemBounds: CGRect = CGRect(origin: .zero, size: CGSize(width: bundle.bundleWidth, height: bundle.bundleHeight))

            item.onItemLoad(frame: itemBounds)
            item.frame = CGRect(x: 0, y: lastItemY, width: bundle.bundleWidth, height: bundle.bundleHeight)
            item.bindBundle(bundle)
            
            self.addSubview(item)
            
            // Set animation for item which was located in here.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                item.alpha = 0.7
                UIView.animate(withDuration: bundle.animatedInterval) {
                    item.alpha = 1
                }
            }
            
            lastItemY = item.frame.maxY

            let reLayoutItems: Array<GSItem> = activity.items[(index + 1)...].reversed().reversed()
            reLayoutItems.forEach { item in
                item.frame = CGRect(x: item.frame.minX, y: lastItemY, width: item.frame.width, height: item.frame.height)
                lastItemY = lastItemY + item.frame.height
            }

            self.contentSize = CGSize(width: self.frame.width, height: lastItemY)
        }
        
        // Remove a specific item from the current items.
        activity.removeItemBlock = { (index, animated) in
            guard index != activity.items.count else { return }
            let yValue: CGFloat = activity.items[index].frame.minY 
            activity.items[index].removeFromSuperview()
            activity.items.remove(at: index)

            var reLayoutYValue: CGFloat = yValue
            activity.items.forEach { item in
                item.frame = CGRect(x: item.frame.minX, y: reLayoutYValue, width: item.frame.width, height: item.frame.height)
                reLayoutYValue = reLayoutYValue + item.frame.height
            }
        }
        
    }

}

// MARK: - Trait change.
extension GSActivityView {
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard let activity = self.activity else { return }
        guard let previousTraitCollection = previousTraitCollection else { return }
        activity.items.forEach { $0.bundle?.onTraitChanged(previousTraitCollection) }
    }

    @objc open func activityRotate(rawValue: Int) {
        guard let activity = self.activity else { return }
        if !activity.isEnableRotated {
            return
        }
        if activity.isAutoRotatedSelf {
            UIView.animate(withDuration: 0.328) {
                self.frame = CGRect(x: self.frame.minX,
                                    y: self.frame.minY,
                                    width: self.frame.height + self.frame.minY,
                                    height: self.frame.width - self.frame.minY)
            }
        }
        
        var yValue: CGFloat = 0
        
        switch rawValue {
        case 1:
            activity.items.forEach { item in
                item.frame = CGRect(x: 0, y: yValue, width: self.frame.width, height: item.frame.height)
                yValue = yValue + item.frame.height
            }
        case 3:
            activity.items.forEach { item in
                item.frame = CGRect(x: 0, y: yValue, width: self.frame.height, height: item.frame.height)
                yValue = yValue + item.frame.height
            }
        case 4:
            activity.items.forEach { item in
                item.frame = CGRect(x: 0, y: yValue, width: self.frame.height, height: item.frame.height)
                yValue = yValue + item.frame.height
            }
        default:
            break
        }
        
        activity.items.forEach { item in
            guard let bundle: GSBundle = item.bundle else {
                fatalError("The property of SGItem instance object's bundle can not be nil!")
            }
            bundle.rotatedRawValue = rawValue
            item.bindBundle(bundle)
        }
    }
    
}

// MARK: - Hook lifecycle.
extension GSActivityView {
    
    private func setResponder() {
        guard let activity = self.activity else { return }
        
        var vc: UIResponder = self
        while vc.isKind(of: UIViewController.self) != true {
            vc = vc.next!
        }
        
        activity.responder = vc as? UIViewController
    }
    
    @objc open func contextDidLoad() {
        guard let activity = self.activity else { return }
        activity.contextDidLoad()
        activity.items.forEach { $0.bundle?.contextDidLoad() }
    }
    
    @objc open func contextWillAppear() {
        guard let activity = self.activity else { return }
        activity.contextWillAppear()
        activity.items.forEach { $0.bundle?.contextWillAppear() }
    }
    
    @objc open func contextDidAppear() {
        guard let activity = self.activity else { return }
        activity.contextDidAppear()
        activity.items.forEach { $0.bundle?.contextDidAppear() }
    }
    
    @objc open func contextWillDisappear() {
        guard let activity = self.activity else { return }
        activity.contextWillDisappear()
        activity.items.forEach { $0.bundle?.contextWillDisappear() }
    }
    
    @objc open func contextDidDisappear() {
        guard let activity = self.activity else { return }
        activity.contextDidDisappear()
        activity.items.forEach { $0.bundle?.contextDidDisappear() }
    }
    
}

// MARK: - Operation method.
extension GSActivityView {
    
    @objc open func jumpToItem(at index: Int, animated: Bool = true) {
        guard let activity = self.activity else { return }
        let itemY: CGFloat = activity.items[index].frame.minY
        let rect: CGRect = CGRect(x: 0,
                                  y: itemY,
                                  width: self.frame.width,
                                  height: self.frame.height)
        
        self.scrollRectToVisible(rect, animated: animated)
    }
    
    @objc open func jumpToTop(_ animated: Bool = true){
        self.scrollRectToVisible(CGRect(x: self.frame.origin.x,
                                        y: 0,
                                        width: self.frame.size.width,
                                        height: self.frame.size.height), animated: animated)
    }
    
    /**
     Call this method to jump to the bottom edge.
     */
    @objc open func jumpToBottom(_ animated: Bool = true){
        // Scroll distance can not be the max y of content size, decrease 1 for itself is the best way to solve it consequently.
        let distance: CGFloat = self.contentSize.height - 1
        self.scrollRectToVisible(CGRect(x: self.frame.origin.x,
                                        y: distance,
                                        width: self.frame.size.width,
                                        height: self.frame.size.height), animated: animated)
    }
    
    @objc open func setForceReload() {
        reload()
        setNeedsDisplay()
    }
    
    @objc open func setReloadBundle() {
        guard let activity = self.activity else { return }
        activity.items.forEach { item in
            guard let bundle: GSBundle = item.bundle else {
                fatalError("SGItem instance object's bundle can not nil!")
            }
            item.bindBundle(bundle)
        }
    }
    
    @objc open func setEnablePlaceholderItem() {
        guard let activity = self.activity else { return }
        guard let placeholderItem = activity.placeholderItemForSGActivity() else { return }
        
        self.subviews.forEach { $0.isHidden = true }
        self.addSubview(placeholderItem)
    }
    
    @objc open func setDisablePlaceholderItem() {
        guard let activity = self.activity else { return }
        guard let placeholderItem = activity.placeholderItemForSGActivity() else { return }
        
        self.subviews.forEach { $0.isHidden = false }
        placeholderItem.removeFromSuperview()
    }
    
}
