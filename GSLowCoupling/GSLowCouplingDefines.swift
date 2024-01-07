/**
 * Copyright mcry416(mcry416@outlook.com). and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

typealias LInt     = Listener<Int>
typealias LString  = Listener<String>
typealias LCGFloat = Listener<CGFloat>
typealias LCGRect  = Listener<CGRect>
typealias LArray   = Listener<Array<Any>>

final public class Listener<T> {
    
    public typealias OnChangeBlock = (_ value: T) -> Void
    
    private(set) var value: T!
    
    private var onChangeBlock: OnChangeBlock?
    
    private var onInfluenceBlock: OnChangeBlock?
    
    init(_ value: T!) {
        self.value = value
        onInfluenceBlock?(value)
    }
    
    public func change(_ value: T) {
        self.value = value
        onInfluenceBlock?(value)
        onChangeBlock?(value)
    }
    
    public func onChanged(_ listener: @escaping OnChangeBlock) {
        onChangeBlock = { value in
            listener(value)
        }
    }
    
    public func onInfluenced(_ listener: @escaping OnChangeBlock) {
        onInfluenceBlock = { value in
            listener(value)
        }
    }
    
}

