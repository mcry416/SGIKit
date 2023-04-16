//
//  Math.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/3/2.
//

import UIKit

class Math: NSObject {
    
    public static var pi: Double { Double.pi }
    
    public static var randomCondition: Bool {
        arc4random() % 2 == 0
    }
    
    public static var randomInt: Int { Int(arc4random()) }
    
    public static var randomFloat: Double { drand48() }
    
    public static func randomInt(end: Int) -> Int{
        Int(arc4random_uniform(UInt32(end)))
    }
    
    public static func maxs(others: Int...){
        
    }
    
    public static func mins(others: Int...){
        
    }
    
    public static func maxs(others: Float...){
        
    }
    
    public static func mins(others: Float...){
        
    }

}
