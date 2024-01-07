//
//  SGButtonTypealias.swift
//  SGIKit
//
//  Created by MCRY416 iMac on 2021/12/19.
//

import UIKit

extension SGButton {
    
    /**
     Set on SGButton click listener. Corresponding to it is touchUpInside in UIButton.Event.
     - Returns: Void.
     */
    typealias SetOnButtonClickListener = () -> Void

    /**
     Set on SGButton touch listener. Corresponding to it is touchDown in UIButton.Event.
     - Returns: Void.
     */
    typealias SetOnButtonTouchListener = () -> Void
}
