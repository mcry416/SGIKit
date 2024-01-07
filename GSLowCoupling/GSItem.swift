/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

open class GSItem: UIView {

    open var bundle: GSBundle?

}

extension GSItem {
    
    /**
     Setup subiews by this method. Instead of using `override init(frame:)`.
     */
    @objc open func onItemLoad(frame: CGRect) {
        
    }
    
    /**
     To bind a bundle (a series field and closure in plain object) operation for SGItem instance.
     - Parameter bundle: Bind object and closure class.
     */
    @objc open func bindBundle(_ bundle: GSBundle) {
        
    }
    
}
