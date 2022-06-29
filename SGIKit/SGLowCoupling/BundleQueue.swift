//
//  BundleQueue.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/6/24.
//

import Foundation

/**
 Used for store hashValue of SGItem, and its capacity is 2.
 */
public struct BundleQueue<T> {
    private var data = [T]()
     
    public init() {}
 
    @discardableResult
    public mutating func dequeue() -> T? {
        return data.removeFirst()
    }
 
    public func peek() -> T? {
        return data.first
    }
 
    public mutating func enqueue(element: T) {
        if data.count > 2 {
            dequeue()
        }
        data.append(element)
    }
 
    public mutating func clear() {
        data.removeAll()
    }
 
    public var count: Int {
        return data.count
    }
 
    public var capacity: Int {
        get {
            return data.capacity
        }
        set {
            data.reserveCapacity(newValue)
        }
    }
 
    public func isFull() -> Bool {
        return count == data.capacity
    }

    public func isEmpty() -> Bool {
            return data.isEmpty
    }
         
}

