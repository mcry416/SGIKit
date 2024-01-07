/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

public class LayoutXAxisProperty {
    
    enum AxisType {
        case leading
        case trailing
        case left
        case right
        case centerX
    }
    
    internal var didConstraintBlock: ((NSLayoutConstraint) -> Void)?
    private let view: UIView
    private let axisType: AxisType
    
    internal init(view: UIView, axisType: AxisType) {
        self.view = view
        self.axisType = axisType
    }
    
    @discardableResult
    public func equalTo(_ anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch axisType {
        case .leading:
            constraint = view.leadingAnchor.constraint(equalTo: anchor, constant: offset)
        case .trailing:
            constraint = view.trailingAnchor.constraint(equalTo: anchor, constant: offset)
        case .left:
            constraint = view.leftAnchor.constraint(equalTo: anchor, constant: offset)
        case .right:
            constraint = view.rightAnchor.constraint(equalTo: anchor, constant: offset)
        case .centerX:
            constraint = view.centerXAnchor.constraint(equalTo: anchor, constant: offset)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch axisType {
        case .leading:
            constraint = view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .trailing:
            constraint = view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .left:
            constraint = view.leftAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .right:
            constraint = view.rightAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .centerX:
            constraint = view.centerXAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }

    @discardableResult
    public func lessThanOrEqualTo(_ anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch axisType {
        case .leading:
            constraint = view.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .trailing:
            constraint = view.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .left:
            constraint = view.leftAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .right:
            constraint = view.rightAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .centerX:
            constraint = view.centerXAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
}
