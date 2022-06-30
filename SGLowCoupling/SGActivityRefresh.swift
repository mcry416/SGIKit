//
//  SGActivityRefresh.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/6/12.
//

import UIKit

extension SGActivity: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
   //     activityDelegate?.sgActivityWillRefresh?(self)
//        Log.debug("content offset: \(scrollView.contentOffset)")
//        Log.debug("visiable size: \(scrollView.visibleSize)")

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
  //      activityDelegate?.sgActivityDidRefresh?(self)
        if contentOffset.y < -100 {
            isScrollToTopTouchOff = true
        
        } else {
            isScrollToTopTouchOff = false
        }


//        Log.warning("content offset: \(scrollView.contentOffset)")
//        Log.warning("visiable size: \(scrollView.visibleSize)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        Log.error("content offset: \(scrollView.contentOffset)")
//        Log.error("visiable size: \(scrollView.visibleSize)")
    }
    
}
