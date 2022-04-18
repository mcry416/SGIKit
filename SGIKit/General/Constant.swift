//
//  Constant.swift
//  LightCamera
//
//  Created by Eldest's MacBook on 2022/3/30.
//

import Foundation
import UIKit

// MARK: - Variables & Constan.
let kSCREEN_WIDTH: CGFloat    = UIScreen.main.bounds.width

let kSCREEN_HEIGHT: CGFloat   = UIScreen.main.bounds.height

let kHALF_WIDTH: CGFloat      = UIScreen.main.bounds.width / 2

let kHALF_HEIGHT: CGFloat     = UIScreen.main.bounds.height / 2

let kCENTER_POINT: CGPoint    = CGPoint(x: kHALF_WIDTH, y: kHALF_HEIGHT)

let window                    = UIApplication.shared.keyWindow

let kTOP_PADDING: CGFloat     = window?.safeAreaInsets.top ?? 0

let kBOTTOM_PADDING: CGFloat  = window?.safeAreaInsets.bottom ?? 0

let kEDGE_PADDING_12: CGFloat = 12

let kEDGE_PADDING_14: CGFloat = 14

let kEDGE_PADDING_16: CGFloat = 16

let k12: CGFloat              = kEDGE_PADDING_12

let k14: CGFloat              = kEDGE_PADDING_14

let k16: CGFloat              = kEDGE_PADDING_16






// MARK: - Functions.

/**
 Accroding to a given value by its root position value to caculate its center posotion value.
 - Note  Parameter of root must be bigger than 0 rather than less or equipment 0.
 - Parameter root: A position value of value's root content.
 - Parameter value:
 - Returns: Center position value.
 */
func centerWith(_ root: CGFloat, selfValue value: CGFloat) -> CGFloat{
    guard root > 0 else { return 0 }
    return (root / 2) - (value) / 2
}

/**
 According to a concrete scale division relationship and widget parameter  to get a concrete widget value.
 - Note Exception will dispaly in the console when parameter was wrong.
 - Parameter length: Widget width.
 - Parameter count: Widget count, scilicet the count of item in root container.
 - Parameter index: Widget position in root container.
 - Parameter root: Root container length.
 - Parameter padding: Left padding screen edge, left padding equals to right padding mustly.
 - Returns: Concrete widget value.
 */
func divisionMagni(_ length: CGFloat, itemCount count: Int, locationIndex index: Int, rootLength root: CGFloat = kSCREEN_WIDTH, edgePadding padding: CGFloat = k16) -> CGFloat{
    assert(length > 0, "length must be bigger than 0.")
    assert(count > 0, "Item in root content must be bigger than 0.")
    assert(index >= 0, "location index can not be under zero.")
    assert(root >= length, "root lenght can not less than length.")
    let space = root - (padding * 2) - (length * CGFloat(count))
    let value = CGFloat(index) * (length + space) + padding
    return value
}
