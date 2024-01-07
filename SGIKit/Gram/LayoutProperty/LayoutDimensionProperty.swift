/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

public class LayoutDimensionProperty {
    
    enum DimensionType {
        case width
        case height
    }
    
    internal var didConstraintBlock: ((NSLayoutConstraint) -> Void)?
    private let view: UIView
    private let dimensionType: DimensionType
    
    internal init(view: UIView, dimensionType: DimensionType) {
        self.view = view
        self.dimensionType = dimensionType
    }
    
    @discardableResult
    public func equalTo(_ c: CGFloat) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch dimensionType {
        case .width:
            constraint = view.widthAnchor.constraint(equalToConstant: c)
        case .height:
            constraint = view.heightAnchor.constraint(equalToConstant: c)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
    @discardableResult
    public func equalTo(_ dimension: NSLayoutDimension) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch dimensionType {
        case .width:
            constraint = view.widthAnchor.constraint(equalTo: dimension)
        case .height:
            constraint = view.heightAnchor.constraint(equalTo: dimension)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }

    @discardableResult
    public func greaterThanOrEqualTo(_ c: CGFloat) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch dimensionType {
        case .width:
            constraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: c)
        case .height:
            constraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: c)
        }

        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ dimension: NSLayoutDimension, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch dimensionType {
        case .width:
            constraint = view.widthAnchor.constraint(greaterThanOrEqualTo: dimension, constant: offset)
        case .height:
            constraint = view.heightAnchor.constraint(greaterThanOrEqualTo: dimension, constant: offset)
        }

        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }

    @discardableResult
    public func lessThanOrEqualTo(_ c: CGFloat) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch dimensionType {
        case .width:
            constraint = view.widthAnchor.constraint(lessThanOrEqualToConstant: c)
        case .height:
            constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: c)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ dimension: NSLayoutDimension, offset: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint?
        
        switch dimensionType {
        case .width:
            constraint = view.widthAnchor.constraint(lessThanOrEqualTo: dimension, constant: offset)
        case .height:
            constraint = view.heightAnchor.constraint(lessThanOrEqualTo: dimension, constant: offset)
        }
        
        guard let constraint = constraint else { return NSLayoutConstraint() }
        didConstraintBlock?(constraint)
        return constraint
    }
    
}
