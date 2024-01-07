//
//  CGSize+Extension.swift
//  ComplexRecordingVideo
//
//  Created by Eldest's MacBook on 2023/11/19.
//

import Foundation

extension CGSize {
    
    public enum PlatformValueType: CGFloat {
        case phone      = 1.0
        case versionPad = 1.3
        case halfPad    = 1.5
        case fullPad    = 2.0
    }
    
    public func fit(_ type: PlatformValueType) -> CGSize {
        if kIS_PHONE {
            return self
        } else if kIS_PAD {
            return CGSize(width: self.width * type.rawValue, height: self.height * type.rawValue)
        } else {
            return self
        }
    }
    
}
