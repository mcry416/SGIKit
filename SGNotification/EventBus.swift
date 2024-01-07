//
//  File.swift
//  
//
//  Created by Eldest's MacBook on 2024/1/4.
//

import Foundation

/**
 Using convenience method of `post` and `on` to control NSNotificationCenter.
 - eg. using `post("AppDidLockScreen")` to post a NSNotification, and listen this by `on("AppDidLockScreen") { obj in }`.
 */
public class EventBus: NSObject {
    
    public typealias ActionBlock = ( _ obj: Any?) -> Void
    
    public static let singston: EventBus = { EventBus() }()
    
    private lazy var keyCache: Array<String> = { Array<String>() }()
    
    private lazy var event_queue: DispatchQueue = { DispatchQueue(label: "com.sg.event_bus") }()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Post
    
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
    
    // MARK: - On
    
    public func on(_ key: String, _ handler: ActionBlock?){
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
        NotificationCenter.default.removeObserver(self, forKeyPath: key)
    }
    
}

