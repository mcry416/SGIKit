//
//  Bind.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/1.
//

import UIKit

extension UIViewController{
    
    @discardableResult
    func Bind(_ bind: Int) -> UIImageView{
  //      assert(self.view.viewWithTag(BindRegisteCenter.single.getRegisterTag(bind: bind)) != nil, "Bind failed, the cause of the crash is that there is no view available, check the parameter in DSL.")
        return view.viewWithTag(bind) as! UIImageView
    }
    
    @discardableResult
    func Bind(_ bind: Int) -> UILabel{
        return view.viewWithTag(bind) as! UILabel
    }
    
    @discardableResult
    func Bind(_ bind: Int) -> IFButton{
        return view.viewWithTag(bind) as! IFButton
    }
    
}

