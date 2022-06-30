//
//  SGFrgamentDelegate.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/4/16.
//

import UIKit

@objc protocol SGFragmentDelegate{
    
    /**
     Return items count where in the fragment.
     - Parameter fragment: SGFragment instance, user could ignore this. It means only concrete fragment in the activity generallery speaking.
     - Returns: items count.
     */
    func numberOfItemForFragment(_ fragment: SGFragment) -> Int
    
    /**
     Return concrete position SGItem instance by index in the fragment.
     - Parameter fragment: SGFragment instance, user could ignore this. It means only concrete fragment in the activity generallery speaking.
     - Parameter index: SGItem position that located in `self.items`, could ignored it when using.
     - Returns: SGItem instance, which ought to be view layer.
     */
    func itemAtIndex(_ index: Int, fragment: SGFragment) -> SGItem
    
}
