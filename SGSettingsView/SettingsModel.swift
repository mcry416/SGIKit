//
//  SettingsModel.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/1.
//

import UIKit

open class SettingsModel: NSObject {
    
   public enum SettingsType {
        /// A style with a "Right" signal
        case done
        /// A style with a right arrow.
        case enter
        /// A style with a UISwitch widget.
        case switchType
        /// Nothing.
        case blank
    }
    
    open var isSwitchEnable: Bool = false
    /// Right content.
    open var text: String!
    /// Cell type.
    open var type: SettingsType!
    /// Optional resource content.
    open var res: String?
    
    public init(text: String, type: SettingsType, res: String?) {
        self.text = text
        self.type = type
        self.res = res
    }
}
