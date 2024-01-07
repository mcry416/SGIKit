/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
//  Created by MengQingyu iMac on 2022/8/22.

import UIKit

// MARK: - LayoutMaker

public class LayoutMaker {
    
    public lazy var leading  = LayoutXAxisProperty(view: view, axisType: .leading)
    public lazy var trailing = LayoutXAxisProperty(view: view, axisType: .trailing)
    public lazy var left     = LayoutXAxisProperty(view: view, axisType: .left)
    public lazy var right    = LayoutXAxisProperty(view: view, axisType: .right)
    public lazy var centerX  = LayoutXAxisProperty(view: view, axisType: .centerX)
    public lazy var top      = LayoutYAxisProperty(view: view, axisType: .top)
    public lazy var bottom   = LayoutYAxisProperty(view: view, axisType: .bottom)
    public lazy var centerY  = LayoutYAxisProperty(view: view, axisType: .centerY)
    public lazy var width    = LayoutDimensionProperty(view: view, dimensionType: .width)
    public lazy var height   = LayoutDimensionProperty(view: view, dimensionType: .height)
    public lazy var size     = LayoutSizeProperty(view: view)
    
    internal var activate: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    private let view: UIView

    fileprivate init(view: UIView) {
        self.view = view
        
        leading.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        trailing.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        left.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        right.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        centerX.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        top.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        bottom.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        centerY.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        width.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        height.didConstraintBlock = { [weak self] constraint in
            guard let `self` = self else { return }
            self.activate.append(constraint)
        }
        size.didConstraintBlock = { [weak self] constraints in
            guard let `self` = self else { return }
            constraints.forEach{ self.activate.append($0) }
        }
    }
    
}

// MARK: - gram.layout

public protocol GramProtocol { }

public struct GramNamespace<T>: GramProtocol {
    
    public typealias WrappedType = T
    
    public let base: T
    init(_ base: T) {
        self.base = base
    }
    
}

extension GramProtocol {
    
    public var gram: GramNamespace<Self> {
        get { GramNamespace(self) }
        set {}
    }
    
}

extension UIView: GramProtocol { }

extension GramNamespace where T: UIView {
    
    public func layout(_ closure: (_ make: LayoutMaker) -> Void) {
        assert(self.base.superview != nil, "before making constraints, the view must be added into a superview!")
        self.base.translatesAutoresizingMaskIntoConstraints = false
        let layoutMaker = LayoutMaker(view: self.base)
        closure(layoutMaker)
        NSLayoutConstraint.activate(layoutMaker.activate)
    }
    
    var leading: NSLayoutXAxisAnchor {
        base.leadingAnchor
    }
    
    var trailing: NSLayoutXAxisAnchor {
        base.trailingAnchor
    }
    
    var left: NSLayoutXAxisAnchor {
        base.leftAnchor
    }
    
    var right: NSLayoutXAxisAnchor {
        base.rightAnchor
    }
    
    var centerX: NSLayoutXAxisAnchor {
        base.centerXAnchor
    }
    
    var top: NSLayoutYAxisAnchor {
        base.topAnchor
    }
    
    var bottom: NSLayoutYAxisAnchor {
        base.bottomAnchor
    }
    
    var centerY: NSLayoutYAxisAnchor {
        base.centerYAnchor
    }
    
    var width: NSLayoutDimension {
        base.widthAnchor
    }
    
    var height: NSLayoutDimension {
        base.heightAnchor
    }

}
