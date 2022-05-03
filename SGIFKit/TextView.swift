//
//  TextView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/30.
//

import UIKit

extension UIViewController{
    
    @discardableResult
    func TextView(text: String,
                  color: UIColor = .black,
                  fontSize: CGFloat = 16,
                  fontWeight: UIFont.Weight = .light,
                  bind: Int = 0) -> UILabel{
        
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = .center
        label.frame.size = CGSize(width: text.getTextFitWidth() + 20,
                                  height: text.getTextHeight())
        
        return label
    }
}
