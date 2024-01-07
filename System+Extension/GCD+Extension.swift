//
//  GCD+Extension.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/3/2.
//

import Foundation

// MARK: - Once.
extension DispatchQueue {
    
    private static var _onceTokenDictionary: [String: String] = { [: ] }()
    
    static public func once(token: String, _ block: (() -> Void)){
        defer { objc_sync_exit(self) }
        objc_sync_enter(self)
        
        if _onceTokenDictionary[token] != nil {
            return
        }

        _onceTokenDictionary[token] = token
        block()
    }
    
}
