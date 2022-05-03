//
//  HLayout.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/30.
//

import UIKit

extension UIViewController{
    
    @discardableResult
    func HLayout(width: CGFloat = kSCREEN_WIDTH,
                 color: UIColor = .white,
                 padding: CGFloat = 0,
                 layout: (() -> Array<UIView>)?) -> UIView{
        let rect: CGRect = CGRect(x: 0,
                                  y: kTOP_PADDING,
                                  width: kSCREEN_WIDTH,
                                  height: kSCREEN_WIDTH * 0.16)
        let view = UIView(frame: rect)
        view.backgroundColor = color
   //     self.view.addSubview(view)
        
        guard layout?() != nil else {
            return UIView()
        }
        
        let tempSubviews: Array<UIView> = layout!()
        var tempSubviewRect: CGRect = .zero
        
        for index in 0..<tempSubviews.count {
            let frame: CGRect = CGRect(x: tempSubviewRect.minX,
                                       y: kTOP_PADDING - rect.minY,
                                       width: rect.width / CGFloat(tempSubviews.count),
                                       height: rect.height)
            tempSubviews[index].frame = frame
            tempSubviewRect.origin.x = frame.minX + frame.width
            view.addSubview(tempSubviews[index])
        }
        
        return view
    }
    
    
}
