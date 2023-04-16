//
//  EventBus.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/4/9.
//

import Foundation

class EventBus: NSObject {
    
    typealias ActionBlock = ( _ obj: Any?) -> Void
    
    public static let singston: EventBus = { EventBus() }()
    
    private lazy var keyCache: Array<String> = { Array<String>() }()
    
    private lazy var event_queue: DispatchQueue = { DispatchQueue(label: "com.sg.event_bus") }()
    
    private override init() {
        super.init()
    }
    
    public func post(_ key: String, object: Any? = nil){
        keyCache.append(key)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: key), object: object )
    }
    
    public func postOnMain(_ key: String, object: Any? = nil){
        OperationQueue.main.addOperation {
            self.post(key, object: object)
        }
    }
    
    public func postOnSub(_ key: String, object: Any? = nil){
        event_queue.async {
            self.post(key, object: object)
        }
    }
    
    public func on(_ key: String, _ handler: ActionBlock?){
        if !keyCache.contains(key) {
            Log.warning("Operation of `on` has influented nil target cause Notification did not have post the key.")
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: key), object: nil, queue: nil) { notif in
            handler?(notif.object)
        }
        
    }
    
    public func onMain(_ key: String, _ handler: ActionBlock?){
        OperationQueue.main.addOperation {
            self.on(key) { obj in
                handler?(obj)
            }
        }
    }
    
    public func onSub(_ key: String, _ handler: ActionBlock?){
        event_queue.async {
            self.on(key) { obj in
                handler?(obj)
            }
        }
    }
    
    public func off(_ key: String){
        if !keyCache.contains(key) {
            Log.error("Operation of `off` has influented nil target cause Notification did not have post the key.")
            return
        }
        NotificationCenter.default.removeObserver(self, forKeyPath: key)
    }
    
}

