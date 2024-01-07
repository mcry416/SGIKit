/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

open class GSBundle: NSObject {
    
    open var animatedInterval: TimeInterval = 0.382
    
    open var bundleWidth: CGFloat = 0
    
    open var bundleHeight: CGFloat = 0
    
    open var rotatedRawValue: Int = 1
    
    /** Indicate the fragment is effective in portrait mode to show. */
    open var isEffectiveInPortrait: Bool = true
    
    /** Indicate the fragment is effective in landscape mode to show. */
    open var isEffectiveInLandscape: Bool = false
    
    public var isNeedUpdate: Bool = false
    
    internal var bundleUpdateBlock: (() -> Void)?
    
    final public func update(){
        isNeedUpdate = true
        bundleUpdateBlock?()
    }
    
}

extension GSBundle {
    
    @objc open func onCreate() {
        
    }
    
    @objc open func onTraitChanged(_ previousTraitCollection: UITraitCollection) {
        
    }
    
    @objc open func contextDidLoad() {
        
    }
    
    @objc open func contextWillAppear() {
        
    }
    
    @objc open func contextDidAppear() {
        
    }
    
    @objc open func contextWillDisappear() {
        
    }
    
    @objc open func contextDidDisappear() {
        
    }
    
}
