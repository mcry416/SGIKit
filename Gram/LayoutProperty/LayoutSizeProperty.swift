/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

public class LayoutSizeProperty {
    
    internal var didConstraintBlock: (([NSLayoutConstraint]) -> Void)?
    private let view: UIView
    
    internal init(view: UIView) {
        self.view = view
    }
    
    public func equalTo(_ size: CGSize) {
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        let widthConstraint = view.widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: size.height)
        constraints.append(widthConstraint)
        constraints.append(heightConstraint)
        
        didConstraintBlock?(constraints)
    }
    
}

