/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

open class GSHeightBundle: GSBundle {
    
    open var color: UIColor = .white
    
    convenience init(height: CGFloat, color: UIColor = UIColor.white) {
        self.init()
        self.bundleHeight = height
        self.color = color
    }
    
}
