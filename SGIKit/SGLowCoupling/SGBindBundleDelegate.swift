//
//  SGBindBundle.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/17.
//

import UIKit

/**
  SGLowCoupling a data-driven delegate.
 */
@objc protocol SGBindBundleDelegate{
    
    /**
     To bind a bundle (a series field and closure in plain object) operation for SGItem instance.
     - Implements this method and create a bundle class.
     - Parameter bundle: Optional plain object and closure class.
     */
    @objc dynamic func bindBundle(_ bundle: Any?)
    
    /**
     To bind a bundle (a series field and closure in plain object) operation for SGItem instance for landscape mode, which is unnecessary for item to override.
     - Implements this method and create a bundle class.
     - It's unnecessary for item to override when Activity is portrait mode.
     - Parameter bundle: Optional plain object and closure class.
     */
    @objc dynamic func bindBundleLandscape(_ bundle: Any?)
}
