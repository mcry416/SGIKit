/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

open class GSHeightItem: GSItem {
    
    open var heightBundle: GSHeightBundle?

    open override func bindBundle(_ bundle: GSBundle) {
        guard let heightBundle = bundle as? GSHeightBundle else { return }
        
        self.backgroundColor = heightBundle.color
    }

}
