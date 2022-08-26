//
//  Log.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/2/14.
//

import Foundation

class Log{
    
    public static func verbose<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            print("------> 🟪 [VERBOSE] \(fileName):\(line) \(function) || \(message) 🟪")
        #endif
    }
    
    public static func debug<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = dformatter.string(from: Date())
            print("------> 🟩 [DEBUG] \(dateStr) \(fileName):\(line) \(function) || \(message) 🟩")
        #endif
    }
    
    public static func info<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = dformatter.string(from: Date())
            print("------> 🟦 [INFO] \(dateStr) \(fileName):\(line) \(function) || \(message) 🟦")
        #endif
    }
    
    public static func warning<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = dformatter.string(from: Date())
            print("------> 🟨 [WARNING] \(dateStr) \(fileName):\(line) \(function) || \(message) 🟨")
        #endif
    }
    
    public static func error<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = dformatter.string(from: Date())
            print("------> 🟥 [ERROR] \(dateStr) \(fileName):\(line) \(function) || \(message) 🟥")
        #endif
    }
    
        public static func timeline( _ completionHandler: @escaping (() -> Void)){
        #if DEBUG
            let dformatter = DateFormatter()
            dformatter.dateFormat = "HH:mm:ss"
            let dateStr = dformatter.string(from: Date())
            let startTime = CFAbsoluteTimeGetCurrent()
            completionHandler()
            let endTime = CFAbsoluteTimeGetCurrent()
            print("------> 🟥 [TIMELINE] \(dateStr) || Consume time: \((endTime - startTime) * 1000)ms🟥")
        #endif
    }
    
}
