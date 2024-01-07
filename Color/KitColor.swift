//
//  KitColor.swift
//  
//
//  Created by Eldest's MacBook on 2023/12/13.
//

import UIKit

open class KitColor: NSObject {

    public static func gray5() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray6
        } else {
            return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 0)
        }
    }
    
    public static func black() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(named: "SGColor_black") ?? .black
        } else {
            return UIColor.black
        }
    }
    
    public static func white1() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(named: "SGColor_white1") ?? .white
        } else {
            return UIColor.white
        }
    }
    
    public static func normalBgGrey() -> UIColor {
        UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }
    
    public static func bg_gray_light() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray6
        } else {
            return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0)
        }
    }
    
}
