//
//  PropertyWrapper.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/5/7.
//

import Foundation
import UIKit

// MARK: - @syncVariable

/** Sync a varible by using `NSLock`. */
@propertyWrapper
public class syncVariable<T> {
    
    private lazy var lock: NSLock = { NSLock() }()
    
    private var _wrappedValue: T?
    public var wrappedValue: T {
        set {
            lock.lock()
            self._wrappedValue = newValue
            lock.unlock()
        }
        get {
            var tempValue: T!
            lock.lock()
            tempValue = self._wrappedValue
            lock.unlock()
            return tempValue
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
}

//  MARK: - @userDefaultsObject

/** Store and read an object by using `UserDefault`. */
@propertyWrapper
class userDefaultsObject<T> {
    
    private var _wrappedValueName: String = ""
    public var wrappedValue: T {
        set { self.setNewValue(newValue) }
        get { self.getValue() }
    }
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    private func setNewValue(_ value: T){
        let userDefalut: UserDefaults = UserDefaults.standard
        self._wrappedValueName = "userDefaultsObject_\(value)"
        userDefalut.set(value, forKey: self._wrappedValueName)
        userDefalut.synchronize()
    }
    
    private func getValue() -> T{
        let userDefalut: UserDefaults = UserDefaults.standard
        return userDefalut.object(forKey: "userDefaultsObject_\(self._wrappedValueName)") as! T
    }
    
}

//  MARK: - @archiveObject

/*
/** Store and read an object by using `c`. */
@propertyWrapper
class archiveObject<T> {
    
    var wrappedValue: T {
        set { self.setNewValue(newValue) }
        get { self.getValue() }
    }
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    private func setNewValue(_ value: T){
        
    }
    
    private func getValue() -> T{
        
    }
    
}
 */

// MARK: - @ceilRect

/** Ceil a CGRect every value. */
@propertyWrapper
struct ceilRect {
    
    var _wrappedValue: CGRect = .zero
    var wrappedValue: CGRect {
        set {
            self._wrappedValue = newValue
        }
        get {
            CGRect(x: ceil(self._wrappedValue.minX),
                   y: ceil(self._wrappedValue.minY),
                   width: ceil(self._wrappedValue.width),
                   height: ceil(self._wrappedValue.height))
        }
    }
    
    init(wrappedValue: CGRect) {
        self.wrappedValue = wrappedValue
    }
    
}
