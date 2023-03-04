//
//  SGItem.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/16.
//

import UIKit

class SGItem: UIView, SGBindBundleDelegate{
    
    private var _bundleHashValue: BundleQueue<Int> = BundleQueue<Int>()
    /// Bundle hash value, only available if the bundle exists.
    public var bundleHashValue: BundleQueue<Int>{
        set{
            _bundleHashValue = newValue
        }
        get{
            return _bundleHashValue
        }
    }
    
    private var _bundle: Any?
    /// SGItem bundle.
    public var bundle: Any?{
        set{
            _bundle = newValue
            let bundleHash = _bundle as! NSObject
            /// Enqueue the has value when changes.
            bundleHashValue.enqueue(element: bundleHash.hashValue)
        }
        get{
            return _bundle
        }
    }
    
    private var _size: CGSize!
    /// CGSize for SGItem.
    public var size: CGSize?{
        set{
            _size = newValue
            self.frame.size = _size
        }
        get{
            return _size
        }
    }
    
    /// Dynamic height for item.
    public var estimateDynamicHeight: CGFloat = 0
    
    /// Store the original width for the screen was rotated. Do not modify this propety anytime.
    public var originalWidth: CGFloat = 0
    
}

// MARK: - Outside method.
extension SGItem{
    
    /**
     When device was rotated and override this method to process the condition of rotated.
     - Parameter rawValue: Spin code, 0 meas normally, 1 means device back, 2 means volume button at the bottom, 3 means power button at the bottom.
     */
    @objc func itemWillRotate(rawValue: Int){
        
    }
    
    /**
     To bind a bundle (a series field and closure in plain object) operation for SGItem instance.
     - Implements this method and create a bundle class.
     - Parameter bundle: Optional plain object and closure class.
     */
    @objc func bindBundle(_ bundle: Any?) {
        
    }
    
    /**
     To bind a bundle (a series field and closure in plain object) operation for SGItem instance for landscape mode, which is unnecessary for item to override.
     - Implements this method and create a bundle class.
     - It's unnecessary for item to override when Activity is portrait mode.
     - Parameter bundle: Optional plain object and closure class.
     */
    @objc func bindBundleLandscape(_ bundle: Any?) {
        
    }
    
}
