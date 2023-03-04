//
//  Linearizer.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2022/10/6.
//

import UIKit

class Linearizer: NSObject {
    
    private var start: CGFloat = 0
    
    private var end: CGFloat = 0
    
    private var filter: CGFloat = 0
    
    /**
     Initlized an linearizer.
     - Parameter start: The minium number.
     - Parameter end: The max number.
     - Parameter filter:  Step number, which must be less than 1.
     */
    init(start: CGFloat, end: CGFloat, filter: CGFloat) {
        self.start = start
        self.end = end
        self.filter = filter
    }
    
    public func get(percent: CGFloat) -> CGFloat{
        let atom: CGFloat = (end - start) * filter

        return start + percent * atom
    }
    
}
