//
//  Double+Extension.swift
//  ComplexRecordingVideo
//
//  Created by Eldest's MacBook on 2023/11/19.
//

import Foundation

extension Double {
    
    public enum PlatformValueType: Double {
        case phone   = 1.0
        case halfPad = 1.5
        case fullPad = 2.0
    }
    
    public func fit(_ type: PlatformValueType) -> CGFloat {
        if kIS_PHONE {
            return self
        } else if kIS_PAD {
            return self * type.rawValue
        } else {
            return self
        }
    }
    
}
