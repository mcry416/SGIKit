//
//  CacheStack.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/7/22.
//

import Foundation

public struct CacheStack<T> {
    private var elements = [T]()
    public init() {}
     
    public mutating func pop() -> T? {
        return self.elements.popLast()
    }
 
    public mutating func push(element: T){
        self.elements.append(element)
    }
     
    public func peek() -> T? {
        return self.elements.last
    }
     
    public func isEmpty() -> Bool {
        return self.elements.isEmpty
    }
     
    public var count: Int {
        return self.elements.count
    }
    
    public var capacity: Int {
        get {
            return elements.capacity
        }
        set {
            elements.reserveCapacity(newValue)
        }
    }
     
}
