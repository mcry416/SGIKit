//
//  BindRegisterCenter.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/1.
//

import UIKit

class BindRegisteCenter: NSObject{

    static let single = BindRegisteCenter()
    
    private var registerTagStart: Int = 1000
    
    private var registerList: Array<BindClass> = Array<BindClass>()

    public func getRegisterTag(bind: String) -> Int{
        assert(bind != "", "Bind parameter must be initlized with an un-blank signal when get.")
        for i in registerList {
            if i.bind == bind {
                Log.debug("bind:\(i.bind) tag:\(i.tag)")
                return i.tag
            }
        }
        return 0
    }
    
    public func register(bind: String) -> Int{
        assert(bind != "", "Bind parameter must be initlized with an un-blank signal.")
        self.registerTagStart = self.registerTagStart + 1
        registerList.append(BindClass(bind: bind, tag: self.registerTagStart))
        return self.registerTagStart
    }
    
}
