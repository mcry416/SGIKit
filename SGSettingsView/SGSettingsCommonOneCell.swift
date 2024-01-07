//
//  SGSettingsCommonOneCell.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/6/18.
//

import UIKit

open class SGSettingsCommonOneCell: UICollectionViewCell {
    
    private var switchValueDidChangeBlock: ((Bool) -> Void)?
    
    open lazy var leftLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    open lazy var rightSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(SGSettingsCommonOneCell.switchValueDidChangeEvent), for: .valueChanged)
        return uiSwitch
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightSwitch)
        
        let cWidth: CGFloat = frame.width
        let cHeight: CGFloat = frame.height
        leftLabel.frame = CGRect(x: 16, y: 0, width: cWidth - 16 * 2 - 40, height: cHeight)
        rightSwitch.frame = CGRect(x: cWidth - 40 - 16, y: 0, width: 0, height: 0)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SGSettingsCommonOneCell {
    
    public func setOnSwitchListener(_ listener: ((_ isOn: Bool) -> Void)?) {
        self.switchValueDidChangeBlock = { isOn in
            listener?(isOn)
        }
    }
    
    @objc private func switchValueDidChangeEvent() {
        self.switchValueDidChangeBlock?(rightSwitch.isOn)
    }
    
}
