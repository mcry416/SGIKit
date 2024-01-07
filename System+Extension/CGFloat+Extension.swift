//
//  CGFloat+Extension.swift
//  ComplexRecordingVideo
//
//  Created by Eldest's MacBook on 2023/11/19.
//

import Foundation

extension CGFloat {
    
    public enum PlatformValueType: CGFloat {
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
