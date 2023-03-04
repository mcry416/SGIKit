//
//  SGActivityDelegate.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/16.
//

import UIKit

/**
 The SGActivity executes interface method.(or named it `ActivityModel`)
 */
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
     Return an optional fragment for the activity, it will show in the activity at the condition of iPhone was rotated, imagine a scene that UIViewController was presented a view in normal mode and the iPhone was rotated, the iPhone was need a new view to present in this scene for user.
     - Parameter activity: SGActivity instance, user could ignore this. It means only concrete viewModel in the ViewContoller generallery speaking.
     - Returns: SGFragment instance that used for iPhone was rotated.
     */
    @objc optional func viceFragmentForSGActivity(_ activity: SGActivity) -> SGFragment?
    
    /**
     Return an optional fragment for the activity, it will show in the activity at the condition of implments this method and called the method of `setEnablePlaceholderFragment()` only.
     - Parameter activity: SGActivity instance, user could ignore this. It means only concrete viewModel in the ViewContoller generallery speaking.
     - Returns: SGFragment instance that used for placeholder.
     */
    @objc optional func placeholderFragmentForSGActivity(_ activity: SGActivity) -> SGFragment?
    
    /**
     Return a attrbuted string for the top refresh control.
     - Parameter activity: SGActivity instance, user could ignore this. It means only concrete viewModel in the ViewContoller generallery speaking.
     - Returns: The attrbuted string for top refresh control.
     */
    @objc optional func topRefreshAttributedTitleForSGActivity(_ activity: SGActivity) -> NSAttributedString?
    
    /**
     When user swiped the top refresh control and listen the action.
     */
    @objc optional func topRefreshListenerForSGActivity(_ activity: SGActivity)
    
    @objc optional func bottomRefreshAttributedTitleForSGActivity(_ activity: SGActivity) -> NSAttributedString?
    
    @objc optional func bottomRefreshListenerForSGActivity(_ activity: SGActivity)
    
    @objc optional func activityWillAppear()
    
    @objc optional func activityDidAppear()
    
    @objc optional func activityDidLoad()
    
    @objc optional func activityWillDisappear()
    
    @objc optional func activityDidDisappear()

}
