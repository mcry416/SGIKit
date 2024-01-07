//
//  SGPopupCenterView.swift
//  ComplexRecordingVideo
//
//  Created by Eldest's MacBook on 2023/11/13.
//

import UIKit

open class SGPopupCenterView: UIView {
    
    private static var showAnimation: CAAnimation = getShowAnimation()
    private static var hideAnimation: CAAnimation = getHideAnimation()

    private lazy var contentView: UIView = UIView()
    private lazy var decorateView: UIView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        self.addSubview(decorateView)
        decorateView.addSubview(contentView)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch: UITouch = event?.touches(for: self)?.first else { return }
        let touchPoint: CGPoint = touch.location(in: decorateView)
        
        let _: Bool = touchPoint.x >= decorateView.frame.minX && touchPoint.x <= decorateView.frame.maxX
        let _: Bool = touchPoint.y >= decorateView.frame.minY && touchPoint.y <= decorateView.frame.maxY
        
        self.hide()
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let touch: UITouch = event?.touches(for: self)?.first else {
            return super.hitTest(point, with: event)
        }
        let touchPoint: CGPoint = touch.location(in: decorateView)
        
        let isInX: Bool = touchPoint.x >= decorateView.frame.minX && touchPoint.x <= decorateView.frame.maxX
        let isInY: Bool = touchPoint.y >= decorateView.frame.minY && touchPoint.y <= decorateView.frame.maxY
        
        if isInX && isInY {
            return decorateView
        }
        
        return super.hitTest(point, with: event)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = decorateView.bounds
        
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        decorateView.layer.shadowColor = UIColor.black.cgColor
        decorateView.layer.shadowOffset = CGSizeMake(0, 0)
        decorateView.layer.shadowRadius = 8
        decorateView.layer.shadowOpacity = 0.5
        decorateView.layer.shadowPath = UIBezierPath(rect: decorateView.bounds).cgPath
    }
    
}

// MARK: - Animation & Event
extension SGPopupCenterView {
    
    @objc
    open func addSubContentView(_ view: UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    @objc
    open func show(size: CGSize) {
        guard let window: UIWindow = UIApplication.shared.keyWindow else { return }
        window.addSubview(self)
        self.addSubview(decorateView)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            
        }
        
        decorateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            decorateView.widthAnchor.constraint(equalToConstant: size.width),
            decorateView.heightAnchor.constraint(equalToConstant: size.height),
            decorateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            decorateView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        decorateView.layer.add(Self.showAnimation, forKey: nil)
        CATransaction.commit()
        
    }
    
    @objc
    open func hide() {
        let transform: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        var values: Array<NSValue> = Array<NSValue>()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.15, 1.15, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        transform.values = values
        
        UIView.animate(withDuration: 0.2) {
//            self.decorateView.layer.add(Self.hideAnimation, forKey: nil)
            self.decorateView.alpha = 0
        } completion: { (res) in
            self.decorateView.layer.removeAnimation(forKey: "transform")
            self.decorateView.layer.removeAnimation(forKey: "opacity")
            self.decorateView.alpha = 1
            self.removeFromSuperview()
        }
        
        
//        CATransaction.begin()
//        CATransaction.setCompletionBlock {
//            self.decorateView.layer.removeAnimation(forKey: "transform")
//            self.decorateView.layer.removeAnimation(forKey: "opacity")
//            self.decorateView.alpha = 0
//            self.removeFromSuperview()
//        }
//        decorateView.layer.add(Self.hideAnimation, forKey: nil)
//        CATransaction.commit()
    }
    
    private static func getShowAnimation() -> CAAnimation{
        let transform: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        var values: Array<NSValue> = Array<NSValue>()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.90, 0.90, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.15, 1.15, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        transform.values = values
        
        let opacity: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1.0
        
        let group: CAAnimationGroup = CAAnimationGroup()
        group.duration = 0.2
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.animations = [transform, opacity]
        
        return group
    }

    private static func getHideAnimation() -> CAAnimation{
        let transform: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        var values: Array<NSValue> = Array<NSValue>()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.05, 1.05, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.95, 0.95, 1.0)))
        transform.values = values
        
        let opacity: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1.0
        opacity.toValue = 0
        
        let group: CAAnimationGroup = CAAnimationGroup()
        group.duration = 0.2
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.animations = [transform, opacity]
        
        return group
    }

}
