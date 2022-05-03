//
//  VLayout.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/1.
//

import UIKit

extension UIViewController{
    
    func VLayout(width: CGFloat = kSCREEN_WIDTH,
                 color: UIColor = .white,
                 padding: CGFloat = 0,
                 layout: (() -> Array<UIView>)?){
        var rect: CGRect = CGRect(x: 0,
                                  y: kTOP_PADDING,
                                  width: kSCREEN_WIDTH,
                                  height: 1)
        let view = UIView(frame: rect)
        view.backgroundColor = color
        self.view.addSubview(view)
        
        guard layout?() != nil else {
            return
        }
        
        let tempSubviews: Array<UIView> = layout!()
        var tempSubviewRect: CGRect = CGRect(x: 0,
                                             y: kTOP_PADDING - rect.minY,
                                             width: 0,
                                             height: 0)
        
        for index in 0..<tempSubviews.count {
            let frame: CGRect = CGRect(x: tempSubviewRect.minX,
                                       y: tempSubviewRect.origin.y,
                                       width: tempSubviews[index].frame.width,
                                       height: tempSubviews[index].frame.height)
            tempSubviews[index].frame = frame
            tempSubviewRect.origin.y = frame.minY + frame.height
            view.addSubview(tempSubviews[index])
        }
        
        rect = CGRect(x: rect.origin.x,
                      y: rect.origin.y,
                      width: rect.size.width,
                      height: tempSubviewRect.maxY)
        view.frame = rect
        
        
    }
    
}
