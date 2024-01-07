/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

public class LayoutYAxisProperty {
    
    enum YAxisType {
        case top
        case bottom
        case centerY
    }
    
    internal var didConstraintBlock: ((NSLayoutConstraint) -> Void)?
    private let view: UIView
    private let axisType: YAxisType
    
    internal init(view: UIView, axisType: YAxisType) {
        self.view = view
        self.axisType = axisType
    }
    
    @discardableResult
    public func equalTo(_ anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch axisType {
        case .top:
            constraint = view.topAnchor.constraint(equalTo: anchor, constant: offset)
        case .bottom:
            constraint = view.bottomAnchor.constraint(equalTo: anchor, constant: offset)
        case .centerY:
            constraint = view.centerYAnchor.constraint(equalTo: anchor, constant: offset)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch axisType {
        case .top:
            constraint = view.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .bottom:
            constraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .centerY:
            constraint = view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }

    @discardableResult
    public func lessThanOrEqualTo(_ anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch axisType {
        case .top:
            constraint = view.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .bottom:
            constraint = view.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .centerY:
            constraint = view.centerYAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
}
