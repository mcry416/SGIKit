//
//  GramKit.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/22.
//

import Foundation
import UIKit

extension UIView{
    
    var gram_left: CGFloat{
        set{
            
        }
        get{
            return 0
        }
    }
    
    var gram_right: CGFloat{
        set{
            
        }
        get{
            return 0
        }
    }
    
    var gram_top: CGFloat{
        set{
            
        }
        get{
            return 0
        }
    }
    
    var gram_bottom: CGFloat{
        set{
            
        }
        get{
            return 0
        }
    }
    
    var gram_center: CGPoint{
        set{
            
        }
        get{
            return .zero
        }
    }
    
    var gram_edges: UIEdgeInsets{
        set{
            
        }
        get{
            return .zero
        }
    }
    
    func gram_makeConstraints(_ constraints: ((_ make: GramMakeExtenable) -> Void)){
        let maker: GramMakeExtenable = GramMakeExtenable()
        constraints(maker)
        frame = gram_layout(maker)
    }
    
    func gram_updateConstraints(){
        
    }
    
    func gram_removeConstraints(){
        self.frame = .zero
    }
    
    private func gram_layout(_ make: GramMakeExtenable) -> CGRect{
        var rect: CGRect = .zero
        
//        var nonNilChildCount: Int = 0
//        Mirror(reflecting: make).children.forEach { (child) in
//            if child != Optional.none {
//                nonNilChildCount += 1
//            }
//        }
        
        // Width
        if make.makeDescription.width != 0 {
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: make.makeDescription.width!, height: rect.size.height)
        }
        if make.makeDescription.left != 0 && make.makeDescription.right != 0{
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: make.makeDescription.right! - make.makeDescription.left!, height: rect.size.height)
        }

        // Height
        if make.makeDescription.height != 0 {
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.height, height: make.makeDescription.height!)
        }
        if make.makeDescription.top != 0 && make.makeDescription.bottom != 0 {
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.height, height: make.makeDescription.top! - make.makeDescription.bottom!)
        }
        
        // X
        if make.makeDescription.left != 0 {
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.height, height: rect.size.width)
        }
        
        // Y
        
        

        return rect
    }
    
}

public class GramMakeExtenable: GramMakeRelatable{
    
    var width:  GramMakeExtenable{
        self.makeDescription.keyOperation = .width
        return self
    }
    
    var height: GramMakeExtenable{
        self.makeDescription.keyOperation = .height
        return self
    }
    
    var left:   GramMakeExtenable{
        self.makeDescription.keyOperation = .left
        return self
    }
    
    var right:  GramMakeExtenable{
        self.makeDescription.keyOperation = .right
        return self
    }
    
    var top:    GramMakeExtenable{
        self.makeDescription.keyOperation = .top
        return self
    }
    
    var bottom: GramMakeExtenable{
        self.makeDescription.keyOperation = .bottom
        return self
    }

    var size:   GramMakeExtenable{
        self.makeDescription.keyOperation = .size
        return self
    }
    
    var center: GramMakeExtenable{
        self.makeDescription.keyOperation = .center
        return self
    }
    
    var edges:  GramMakeExtenable{
        self.makeDescription.keyOperation = .edges
        return self
    }
}


public class GramMakeRelatable{
    
    var makeDescription: GramMakeDescription!
    
    @discardableResult
    public func equalTo(_ value: CGFloat) -> Self{
        self.relate(value)
        return self
    }
    
    @discardableResult
    public func equalTo(_ value: UIView) -> Self{
        
        return self
    }
    
    @discardableResult
    public func offset(_ value: CGFloat) -> Self{
        
        return self
    }
    
    @discardableResult
    public func equalToSuperView() -> Self{
        
        return self
    }
    
    private func relate(_ value: Any?){
        switch makeDescription.keyOperation {
        case .width:
            makeDescription.width = (value as! CGFloat)
        case .height:
            makeDescription.height = (value as! CGFloat)
        case .left:
            makeDescription.left = (value as! CGFloat)
        case .right:
            makeDescription.right = (value as! CGFloat)
        case .top:
            makeDescription.top = (value as! CGFloat)
        case .bottom:
            makeDescription.bottom = (value as! CGFloat)
        case .size:
            makeDescription.size = (value as! CGFloat)
        case .center:
            makeDescription.center = (value as! CGPoint)
        case .edges:
            makeDescription.edges = (value as! UIEdgeInsets)
        default:
            break
        }
    }
    
}

public class GramMakeDescription{
    
    public enum KeyOperation {
        case width
        case height
        case left
        case right
        case top
        case bottom
        case size
        case center
        case edges
    }
    
    public var width:  CGFloat?

    public var height: CGFloat?

    public var left:   CGFloat?

    public var right:  CGFloat?
    
    public var top: CGFloat?
    
    public var bottom: CGFloat?

    public var size:   CGFloat?
    
    public var center: CGPoint?
    
    public var edges:  UIEdgeInsets?
    
    public var refView: UIView?
    
    public var keyOperation: KeyOperation?
}
