//
//  SGTextItem.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/6/13.
//

import UIKit

class SGTextItem: SGItem {
    
    lazy var label: UILabel = self.createLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func itemWillRotate(rawValue: Int) {
        switch rawValue {
        case 1:
            self.label.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: label.frame.height)
        case 3:
            self.label.frame = CGRect(x: 0, y: 0, width: kSCREEN_HEIGHT, height: label.frame.height)
        case 4:
            self.label.frame = CGRect(x: 0, y: 0, width: kSCREEN_HEIGHT, height: label.frame.height)
        default:
            break
        }
    }
    
    override func bindBundleLandscape(_ bundle: Any?) {
        
    }

}

extension SGTextItem{
    
    convenience init(text: String, centerOffset: CGFloat, backgroundColor: UIColor = .white) {
        self.init()
        
        self.addSubview(label)
        
        label.text = text
    }
    
}

extension SGTextItem{
    
    fileprivate func createLabel() -> UILabel{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 50))
        label.textAlignment = .center
        return label
    }
    
}
