//
//  OS_AVALIABLE.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/3/20.
//

import Foundation

// MARK: - IOS_AVA

public func IOS_AVA_10 (_ handler: (() -> Void), _ elseBlock: (() -> Void)?){
    if #available(iOS 10, *) {
        handler()
    } else {
        elseBlock?()
    }
}

public func IOS_AVA_11 (_ handler: (() -> Void), _ elseBlock: (() -> Void)?){
    if #available(iOS 11, *) {
        handler()
    } else {
        elseBlock?()
    }
}

public func IOS_AVA_12 (_ handler: (() -> Void), _ elseBlock: (() -> Void)?){
    if #available(iOS 12, *) {
        handler()
    } else {
        elseBlock?()
    }
}

public func IOS_AVA_13 (_ handler: (() -> Void), _ elseBlock: (() -> Void)? = nil){
    if #available(iOS 13, *) {
        handler()
    } else {
        elseBlock?()
    }
}

public func IOS_AVA_14 (_ handler: (() -> Void), _ elseBlock: (() -> Void)?){
    if #available(iOS 14, *) {
        handler()
    } else {
        elseBlock?()
    }
}

public func IOS_AVA_15 (_ handler: (() -> Void), _ elseBlock: (() -> Void)?){
    if #available(iOS 15, *) {
        handler()
    } else {
        elseBlock?()
    }
}

public func IOS_AVA_16 (_ handler: (() -> Void), _ elseBlock: (() -> Void)?){
    if #available(iOS 16, *) {
        handler()
    } else {
        elseBlock?()
    }
}

// MARK: - OS_AVA

public func OS_IOS(_ handler: (() -> Void)){
    if #available(iOS 1.0, *){
        handler()
    }
}

public func OS_IPADOS() {
    
}

public func OS_OSX(_ handler: (() -> Void)){
    if #available(macOS 11.0, *){
        handler()
    }
}

public func OS_WATCHOS() {
    
}

