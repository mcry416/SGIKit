//
//  Math.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/3/2.
//

import UIKit

open class Math: NSObject {
    
    public static var pi: Double { Double.pi }
    
    public static var randomBool: Bool {
        arc4random() % 2 == 0
    }
    
    public static var randomInt: Int { Int(arc4random()) }
    
    public static var randomFloat: Double { drand48() }
    
    public static func randomInt(end: Int) -> Int{
        Int(arc4random_uniform(UInt32(end)))
    }
    
    public static func maxs(others: Int...) -> Int? {
        Array(others).max()
    }
    
    public static func mins(others: Int...) -> Int? {
        Array(others).min()
    }
    
    public static func maxs(others: Float...) -> Float? {
        Array(others).max()
    }
    
    public static func mins(others: Float...) -> Float? {
        Array(others).min()
    }

}
