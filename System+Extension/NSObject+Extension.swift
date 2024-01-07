//
//  NSObject+Extension.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/5/20.
//

import Foundation

var sg_nsobject_task_key: Int = 0

extension NSObject {
    
    public typealias TaskBlock = (() -> Void)
    
    public func defaultModeTask(_ task: TaskBlock?){
        objc_setAssociatedObject(self, &sg_nsobject_task_key, task, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.performSelector(onMainThread: #selector(defaultModeTaskMethod), with: nil, waitUntilDone: false, modes: [RunLoop.Mode.default.rawValue])
    }
    
    @objc private func defaultModeTaskMethod(){
        let block = objc_getAssociatedObject(self, &sg_nsobject_task_key) as? TaskBlock
        block?()
    }
    
}
