//
//  HashKVClass.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/6/29.
//

import Foundation

open class HashKVClass: NSObject{
    
    private static var dataBase: [String: Any] = [: ]
    
    static let sharedInstance = HashKVClass()
    
    public static func add(_ key: String, element: Any){
        dataBase[key] = element
    }
    
    public static func delete(_ key: String){
        dataBase.removeValue(forKey: key)
    }
    
    public static func update(_ key: String, newElement element: Any) {
        assert(dataBase[key] != nil, "Update operation must be a non-null key.")
        dataBase[key] = element
    }
    
    public static func get(_ key: String) -> Any?{
        return dataBase[key]
    }
    
    public static func clear(){
        dataBase.removeAll()
    }
    
    public static func size() -> Int{
        return dataBase.count
    }
}
