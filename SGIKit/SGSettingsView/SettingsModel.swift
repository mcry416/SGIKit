//
//  SettingsModel.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/1.
//

import UIKit

class SettingsModel: NSObject {
    
    enum SettingsType {
        /// A style with a "Right" signal
        case done
        /// A style with a right arrow.
        case enter
        /// A style with a UISwitch widget.
        case switchType
        /// Nothing.
        case blank
    }
    
    /// Right content.
    var text: String!
    /// Cell type.
    var type: SettingsType!
    /// Optional resource content.
    var res: String?
    
    init(text: String, type: SettingsType, res: String?) {
        self.text = text
        self.type = type
        self.res = res
    }
}
