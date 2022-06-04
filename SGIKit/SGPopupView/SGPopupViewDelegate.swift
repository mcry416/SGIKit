//
//  SGPopupViewDelegate.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/6/4.
//

import UIKit

/**
 Delegate for SGPopupView.
 - Note SGPopupView is not inherited from UIView, but NSObject.
 */
@objc protocol SGPopupViewDelegate {
    
    /**
     This deleagte method will be executed when the SGPopupView is initlized, that is, SGPopupView is to be showed.
     - Parameter sgPopupView: Executed SGPopupView.
     */
    @objc optional func popupViewWillShow(_ sgPopupView: SGPopupView)
    
    /**
     This delegate method will be executed when the SGPopupView is
     */
    @objc optional func popupViewWillDismiss(_ sgPopupView: SGPopupView)
    
    /**
     This delegate method will be executed when the SGPopupView has been added into UIWindow.
     - Parameter sgPopupView: Executed SGPopupView.
     */
    @objc optional func popupViewDidShow(_ sgPopupView: SGPopupView)
    
    @objc optional func popupViewDidDismiss(_ sgPopupView: SGPopupView)
}
