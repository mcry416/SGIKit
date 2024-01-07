//
//  SGPopupSelectView.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/11/11.
//

import UIKit

open class SGPopupSelectView: UIView {
    
    open var contentEdge: CGFloat = 115
    open var edgeOffset: CGFloat = 3
    open var isAllowMultiSelect: Bool = false
    open var isEnableClickToHide: Bool = true
    
    private var didClickBlock: ((SGPopupSelectModel, Int) -> Void)?
    private let CELL_ID: String = "SGPopupSelectView_CELL_ID"
    private(set) var datas: Array<SGPopupSelectModel> = Array<SGPopupSelectModel>()
    
    private static var showAnimation: CAAnimation = getShowAnimation()
    private static var hideAnimation: CAAnimation = getHideAnimation()

    private lazy var contentView: UIView = UIView()
    private lazy var decorateView: UIView = UIView()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        self.addSubview(decorateView)
        decorateView.addSubview(contentView)
        contentView.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.hide()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = decorateView.bounds
        tableView.frame = decorateView.bounds
        
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        decorateView.layer.shadowColor = UIColor.black.cgColor
        decorateView.layer.shadowOffset = CGSizeMake(0, 0)
        decorateView.layer.shadowRadius = 6
        decorateView.layer.shadowOpacity = 0.3
        decorateView.layer.shadowPath = UIBezierPath(rect: decorateView.bounds).cgPath
        
        self.alpha = 0.86
    }
    
}

// MARK: - Animation & Event
extension SGPopupSelectView {
    
    public func setOnSelectListener(_ handler: ((SGPopupSelectModel, Int) -> Void)?) {
        didClickBlock = handler
    }
    
    public func setData(_ data: Array<SGPopupSelectModel>) {
        self.datas = data
        tableView.reloadData()
    }
    
    public func show(at superContentView: UIView?) {
        guard let superContentView = superContentView else { return }
        guard let window: UIWindow = UIApplication.shared.keyWindow else { return }
        window.addSubview(self)
        self.addSubview(decorateView)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.tableView.flashScrollIndicators()
        }
        setupFrame(withSuperView: superContentView)
        decorateView.layer.add(Self.showAnimation, forKey: nil)
        CATransaction.commit()
        
    }
    
    public func hide() {
        let transform: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        var values: Array<NSValue> = Array<NSValue>()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.95, 0.95, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.05, 1.05, 1.0)))
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
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.95, 0.95, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.05, 1.05, 1.0)))
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
    
    private func setupFrame(withSuperView view: UIView) {
        let width: CGFloat = contentEdge + ceil(textsMaxW(self.datas.map{ $0.title }))
        let height: CGFloat = CGFloat(44 * self.datas.count)
        var y: CGFloat = view.frame.maxY + edgeOffset
        var x: CGFloat = view.frame.midX
        
        x = (x + width > self.bounds.width) ? self.bounds.width - width - 16 : x
        y = (y + height > self.bounds.height) ? self.bounds.height - height - 16 : y
        
        decorateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            decorateView.widthAnchor.constraint(equalToConstant: width),
            decorateView.heightAnchor.constraint(equalToConstant: height),
            decorateView.leftAnchor.constraint(equalTo: view.centerXAnchor),
            decorateView.topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
//        let rect: CGRect = CGRect(x: x, y: y, width: width, height: height)
//        decorateView.frame = rect
    }
    
    private func textsMaxW(_ texts: Array<String>) -> CGFloat {
        return texts.map {
            $0.boundingRect(with:CGSize(width: CGFLOAT_MAX, height: 20), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], context:nil).width
        }.max() ?? 0
    }
    
}

// MARK: - Delegate
extension SGPopupSelectView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        cell.textLabel?.text = datas[indexPath.row].title
        cell.accessoryType = datas[indexPath.row].selectStatus ? .checkmark : .none
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isAllowMultiSelect ? nil : datas.forEach { $0.selectStatus = false }
        datas[indexPath.row].selectStatus = !datas[indexPath.row].selectStatus
        
        didClickBlock?(datas[indexPath.row], indexPath.row)
        
        tableView.reloadData()
        
        if isEnableClickToHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.618) { [weak self] in
                guard let `self` = self else { return }
                self.hide()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
}

open class SGPopupSelectModel: NSObject {
    
    open var title: String = ""
    open var selectStatus: Bool = false
}
