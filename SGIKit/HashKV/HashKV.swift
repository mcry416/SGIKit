//
//  HashKV.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/6/29.
//

import Foundation

class HashKV: NSObject{
    
    private static var safety: NSLock = NSLock()
    
    public static func add(_ key: String, element: Any){
        safety.lock()
        HashKVClass.add(key, element: element)
        safety.unlock()
    }
    
    public static func delete(_ key: String){
        safety.lock()
        HashKVClass.delete(key)
        safety.unlock()
    }
    
    public static func update(_ key: String, newElement element: Any) {
        safety.lock()
        HashKVClass.update(key, newElement: element)
        safety.unlock()
    }
    
    public static func get(_ key: String) -> Any?{
        safety.lock()
        let result = HashKVClass.get(key)
        safety.unlock()
        return result
    }
    
    public static func clear(){
        safety.lock()
        HashKVClass.clear()
        safety.unlock()
    }
    
    public static func size() -> Int{
        safety.lock()
        let size: Int = HashKVClass.size()
        safety.unlock()
        return size
    }
}
