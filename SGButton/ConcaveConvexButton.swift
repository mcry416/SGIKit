//
//  ConcaveConvexButton.swift
//  ComplexRecordingVideo
//
//  Created by Eldest's MacBook on 2023/12/2.
//

import UIKit

open class ConcaveConvexButton: UIView {
    
    open var xMargin: CGFloat = 3 {
        didSet { layoutSubviews() }
    }
    
    open var yMargin: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    
    open var isDisableStyle: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    open lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private var isTouchCancel: Bool = false
    private(set) var isSelectd: Bool = false
    private var didClickBlock: ((Bool) -> Void)?
    
    open var animatedInterval: TimeInterval = 0.5
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.3
        layer.masksToBounds = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: xMargin, y: yMargin, width: self.frame.width - xMargin * 2, height: self.frame.height - yMargin * 2)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
//        UIView.animate(withDuration: 0.5) {
//            self.titleLabel.textColor = self.getColor().0
//            self.backgroundColor = self.getColor().1
//        } completion: { (res) in
//            self.isSelectd
//        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard !isTouchCancel else { return }
        UIView.animate(withDuration: animatedInterval) {
            self.titleLabel.textColor = self.getColor().0
            self.backgroundColor = self.getColor().1
        } completion: { (res) in
            self.isSelectd = !self.isSelectd
        }
        didClickBlock?(self.isSelectd)
        isTouchCancel = false
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        isTouchCancel = true
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard isDisableStyle else { return }
        drawLine(start: CGPoint(x: 0, y: self.frame.height), end: CGPoint(x: self.frame.width, y: 0))
    }
    
    open func setOnClickAction(handler: ((Bool) -> Void)?) {
        didClickBlock = { isSelect in
            handler?(isSelect)
        }
    }
    
    /**
     - Returns: An tuple of `titleColor` and `bakcgoundColor`.
     */
    private func getColor() -> (UIColor, UIColor){
        isSelectd ? (UIColor.black, UIColor.white) : (UIColor.white, UIColor.clear)
    }
    
    private func setDisableStyle(_ isDisable: Bool) {
        let shapeLayer: CAShapeLayer = CAShapeLayer(layer: titleLabel.layer)
        shapeLayer.borderWidth = 1
        shapeLayer.fillColor = UIColor.white.cgColor
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: titleLabel.frame.height))
        path.addLine(to: CGPoint(x: titleLabel.frame.width, y: 0))
        shapeLayer.path = path.cgPath
        titleLabel.layer.addSublayer(shapeLayer)
    }
    
    private func drawLine(start: CGPoint, end: CGPoint) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: start)
        bezierPath.addLine(to: end)
        bezierPath.lineWidth = 1.0
        bezierPath.lineJoinStyle = .round
        bezierPath.close()
        UIColor.white.setStroke()
        bezierPath.fill()
        bezierPath.stroke()
    }
    
}
