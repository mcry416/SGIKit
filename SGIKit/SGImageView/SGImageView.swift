//
//  SGImageView.swift
//  NewNavigationBar
//
//  Created by MengQingyu iMac on 2022/2/11.
//

import UIKit

class SGImageView: UIView {
    
    private var depthImageView: UIImageView!
    private var fontImageView: UIImageView!
    
    private var blurView: UIVisualEffectView!
    
    private var _image: UIImage!
    public var image: UIImage!{
        set{
            _image = newValue
            
            fontImageView.image = _image
            
            let blurEffect = UIBlurEffect(style: .dark)
   //         blurView = UIVisualEffectView(effect: blurEffect)
            blurView.effect = blurEffect
            blurView.layer.masksToBounds = true
            
            depthImageView.addSubview(blurView)
        }
        get{
            return _image ?? UIImage()
        }
    }
    
    override var frame: CGRect{
        didSet{
            let zoomOutRect = CGRect(x: 0,
                                     y: 0,
                                     width: frame.width + 6,
                                     height: frame.height + 6)
            depthImageView = UIImageView(frame: frame)
            fontImageView = UIImageView(frame: zoomOutRect)
            blurView = UIVisualEffectView()
            blurView.frame = frame
            self.addSubview(depthImageView)
            self.addSubview(fontImageView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SGImageView{
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
    }
}
