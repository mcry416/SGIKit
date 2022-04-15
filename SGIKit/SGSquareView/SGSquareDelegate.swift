//
//  SGSquareDelegate.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/3/7.
//

import UIKit

@objc protocol SGSquareDelegate{
    
    /**
     How many items need to show in SGSquareView.
     - When Activity has been setted data source, which should not implements this method generally speaking.
     - When Activity has been setted data source, which will return count of source for Activity, this method will override old count of item for Activity consequentlly.
     - Parameter sgSquareView: SGSquareView.
     - Returns: Int, count of items.
     */
    func numberOfItemForSGSquareView(_ sgSquareView: SGSquareView) -> Int
    
    /**
     According to concrete index to return SGSqaureView instance.
     - Parameter sgSquareView: SGSquareView.
     - Returns: SGSquareViewLattice instance.
     */
    func sgSquareViewAtIndex(_ sgSquareView: SGSquareView, index: Int) -> SGSquareViewLattice
    
    /**
     Which item has been clicked at SGSquareView.
     - Parameter sgSquareView: SGSquareView.
     - Parameter index: The position of item at SGSquareView has been clicked.
     */
    func sgSquareViewClickedAtIndex(_ sgSquareView: SGSquareView, index: Int)
    
    /**
     Return a title view for SGSquareView, which could contanis basic or fully attributes of view variable.
     - Parameter sgSquareView: SGSquareView.
     - Returns: UIView for use to custome.
     */
    @objc optional func titleViewForSGSquareView(_ sgSquareView: SGSquareView) -> UIView
    
    /**
     Return a title for title view(UILabel).
     - Parameter sgSquareView: SGSquareView.
     - Returns: Text of title view.
     */
    @objc optional func titleForSGSquareView(_ sgSquareView: SGSquareView) -> String
    
    /**
     Return a size attributes of CGSzie for title view.
     - Parameter sgSquareView: SGSquareView.
     - Returns: CGSzie for title view.
     */
    @objc optional func titleViewSizeForSGSquareView(_ sgSquareView: SGSquareView) -> CGSize
    
    /**
     Return a size attributes of CGSize for title(UILabel)
     - Returns: CGSize for title.
     */
    @objc optional func titleSizeForSGSquareView(_ sgSquareView: SGSquareView) -> CGSize
    
    /**
     Return a footer view for SGSquareView.
     - Returns: UIView for use to custome at bottom of SGSquareView.
     */
    @objc optional func footerViewForSGSquareView(_ sgSquareView: SGSquareView) -> UIView
    
    /**
     Return a size attributes of CGSize for footerView
     - Returns: CGSize for use to set footer view.
     */
    @objc optional func footerViewSizeForSGSquareView(_ sgSquareView: SGSquareView) -> CGSize
}
