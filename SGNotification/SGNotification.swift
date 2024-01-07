//
//  SGNotification.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/2/14.
//

import UIKit

final public class SGNotification: NSObject {
    
    final class SGNotificationListenerObject: NSObject {
        
        public var observer: NSObject!
        public var name: String!
        public var funcPtr: Selector!
        public var deliverObject: NSObject?
    }
    
    public static var singleston: SGNotification = { SGNotification() }()
    
    private override init() {
        super.init()
    }

    private var observers: Array<SGNotificationListenerObject> = { Array<SGNotificationListenerObject>() }()
    
}

extension SGNotification {
    
    public func addListener(_ listener: NSObject, selector: Selector, name: String){
        let observer: SGNotificationListenerObject = SGNotificationListenerObject()
        observer.observer = listener
        observer.name = name
        observer.funcPtr = selector
        self.observers.append(observer)
    }
    
    public func removeListener(_ listener: NSObject, forName name: String){
        for (idx, obs) in self.observers.enumerated() {
            if listener == obs.observer && name == obs.name {
                self.observers.remove(at: idx)
                break
            }
        }
    }
    
    public func post(_ name: String, deliver objcect: NSObject?){
        for (_, tempObs) in self.observers.enumerated() {
            if tempObs.name == name {
                let performedObject = tempObs.observer
                if let objcect = objcect {
                    performedObject?.perform(tempObs.funcPtr, with: objcect)
                } else {
                    performedObject?.perform(tempObs.funcPtr)
                }
                break
            }
        }
        
    }
    
}
