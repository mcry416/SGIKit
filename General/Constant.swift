//
//  Constant.swift
//  LightCamera
//
//  Created by Eldest's MacBook on 2022/3/30.
//

import Foundation
import UIKit

// MARK: - Variables & Constant.
public let kWHOLE_FRAME: CGRect      = UIScreen.main.bounds

public let kSCREEN_WIDTH: CGFloat    = UIScreen.main.bounds.width

public let kSCREEN_HEIGHT: CGFloat   = UIScreen.main.bounds.height

public let kHALF_WIDTH: CGFloat      = UIScreen.main.bounds.width / 2

public let kHALF_HEIGHT: CGFloat     = UIScreen.main.bounds.height / 2

public let kCENTER_POINT: CGPoint    = CGPoint(x: kHALF_WIDTH, y: kHALF_HEIGHT)

public let kBAR_HEIGHT: CGFloat      = 44

public let kSTATUS_HEIGHT: CGFloat   = 20

public let kWINDOW                   = UIApplication.shared.keyWindow

public let kTOP_PADDING: CGFloat     = kWINDOW?.safeAreaInsets.top ?? 0

public let kBOTTOM_PADDING: CGFloat  = kWINDOW?.safeAreaInsets.bottom ?? 0

public let kEDGE_PADDING_12: CGFloat = 12

public let kEDGE_PADDING_14: CGFloat = 14

public let kEDGE_PADDING_16: CGFloat = 16

public let kSpacing: CGFloat         = 10

public let k12: CGFloat              = kEDGE_PADDING_12

public let k14: CGFloat              = kEDGE_PADDING_14

public let k16: CGFloat              = kEDGE_PADDING_16

public let kVERSION                  = UIDevice.current.systemVersion

public let kORIENTATION              = UIDevice.current.orientation

public let kDEVICE_MODEL: String     = UIDevice.current.model

public let kIS_PHONE: Bool           = UIDevice.current.model == "iPhone"

public let kIS_PAD: Bool             = UIDevice.current.model == "iPad"

public let kIS_FULL_SCREEN: Bool     = (kBOTTOM_PADDING == 0) ? false : true

public let kSAFE_TOP: CGFloat        = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0

public let kSAFE_BOTTOM: CGFloat     = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0

public let kFONT_12: UIFont          = UIFont.systemFont(ofSize: 12)

public let kFONT_13: UIFont          = UIFont.systemFont(ofSize: 13)

public let kFONT_14: UIFont          = UIFont.systemFont(ofSize: 14)

public let kFONT_16: UIFont          = UIFont.systemFont(ofSize: 16)

public let kFONT_18: UIFont          = UIFont.systemFont(ofSize: 18)

// MARK: - Functions.

public func kNAVIGATION_PUSH(_ context: UIViewController, _ vc: UIViewController){
    context.navigationController?.pushViewController(vc, animated: true)
}

public func kNAVIGATION_POP(_ context: UIViewController){
    context.navigationController?.popViewController(animated: true)
}

public func kPRESENT(_ context: UIViewController, _ vc: UIViewController){
    context.present(vc, animated: true)
}

public func kDISMISS( _ vc: UIViewController){
    vc.dismiss(animated: true)
}


public enum PaddingDirection {
    case top
    case bottom
    case left
    case right
}
public func kPADDING(_ value: CGFloat, direction: PaddingDirection, isNeedDivisionFullScreen: Bool = false) -> CGFloat {
    var result: CGFloat = value
    let isFullScreen: Bool = (UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero) != .zero
    
    switch direction {
    case .top:
        break
    case .bottom:
        break
    case .left:
        result = result + (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0)
        if isFullScreen && isNeedDivisionFullScreen {
            result = (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0)
        }
    case .right:
        result = result + (UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0)
        if isFullScreen && isNeedDivisionFullScreen {
            result = (UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0)
        }
    }
    
    return result
}
