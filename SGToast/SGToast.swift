//
//  SGToast.swift
//  LightCamera
//
//  Created by Eldest's MacBook on 2022/4/14.
//

import UIKit

final class Toast: UIView{
    
    public lazy var title: UILabel = self.createTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Toast{
    
    fileprivate func initView(){
        self.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
        self.layer.cornerRadius = 3
        self.addSubview(title)
    }
    
    fileprivate func createTitleLabel() -> UILabel{
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        label.textAlignment = .center
        return label
    }
    
}

extension UIViewController{
    
    public enum ToastLocation {
        case bottom
        case center
        case top
    }
    
    public func toast(_ content: String, location: ToastLocation){
        var toastPoint: CGPoint!
        switch location {
        case .bottom:
            toastPoint = CGPoint(x: self.view.frame.width / 2,
                                 y: 150)
        case .center:
            toastPoint = CGPoint(x: self.view.frame.width / 2,
                                 y: self.view.frame.height / 2)
        case .top:
            toastPoint = CGPoint(x: self.view.frame.width / 2,
                                 y: self.view.frame.height - 150)
        }
        
        let font: UIFont = .systemFont(ofSize: 13, weight: UIFont.Weight.light)
        let MAX_W: CGFloat = kSCREEN_WIDTH - 32 * 2
        var contentSize: CGSize = CGSize(width: content.sg_width(maxH: 25, font: font) + 15, height: 25 + 0)
        let contentMaxH: CGFloat = ceil(content.sg_height(maxW: MAX_W, font: font))
        let contentH: CGFloat = (contentSize.width > MAX_W) ? contentMaxH : 25
        let contentW: CGFloat = (contentSize.width > MAX_W) ? MAX_W : contentSize.width
        contentSize = CGSize(width: contentW, height: contentH)
        
        toastPoint = CGPoint(x: toastPoint.x - contentSize.width / 2,
                             y: toastPoint.y)
        
        let toast = Toast(frame: CGRect(origin: toastPoint, size: contentSize))
        toast.title.frame = CGRect(x: 0,
                                   y: 0,
                                   width: contentSize.width,
                                   height: contentSize.height)
        toast.title.text = content
        self.view.addSubview(toast)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5) {
                toast.alpha = 0
            } completion: { (true) in
                toast.removeFromSuperview()
            }
        }
    }
    
}
