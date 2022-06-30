//
//  SGActivityDelegate.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/16.
//

import UIKit
import CoreMedia

@objc protocol SGActivityDelegate{
    
    /**
     How many fragments should be loaded in activity instance.
     - Parameter activity: SGActivity instance, user could ignore this. It means only concrete viewModel in the ViewContoller generallery speaking.
     - Returns: Fragment counts, include blank fragment.
     */
    func numberOfSGFragmentForSGActivity(_ activity: SGActivity) -> Int
    
    /**
     According to data source( `self.fragments` ) to iterate specified fragment instance.
     - Parameter activity: SGActivity instance, user could ignore this. It means only concrete viewModel in the ViewContoller generallery speaking.
     - Parameter index: SGFragment position that located in `self.fragments`, could ignored it when using.
     - Returns: SGFragment instance.
     */
    @objc optional func fragmentAtIndex(_ activity: SGActivity, index: Int) -> SGFragment
    
    /**
     Return an optional top fragment for acitivity, which is similar to 'Top Notice View', but the fragment  shows the condition that the user has to drop down.
     - Parameter activity: SGActivity instance, user could ignore this. It means only concrete viewModel in the ViewContoller generallery speaking.
     - Returns: SGFragment instance that used for show top view.
     */
    @objc optional func topFragmentForSGActivity(_ activity: SGActivity) -> SGFragment?
    
    /**
     Return an optional bottom fragment for activity, which is similar to 'Bottom Over Notice View', but the fragment shows the condition that the user has to drop up.
     - Parameter activity: SGActivity instance, user could ignore this. It means only concrete viewModel in the ViewContoller generallery speaking.
     - Returns: SGFragment instance that used for show bottom view.
     */
    @objc optional func bottomFragmentForSGActivity(_ activity: SGActivity) -> SGFragment?
    
    /**
     When user will drop down the activity.
     */
    @objc optional func sgActivityWillDropDown(_ activity: SGActivity)
    
    @objc optional func sgActivityDidDropDown(_ activity: SGActivity)
    
    @objc optional func sgActivityWillDropUp(_ activity: SGActivity)
    
    @objc optional func sgActivityDidDropUp(_ activity: SGActivity)
}
