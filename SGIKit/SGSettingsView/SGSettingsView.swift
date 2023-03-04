//
//  SGSettingsView.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/7/15.
//

import UIKit

/**
 SGSettingsView. Used for designed settings view.
 */
class SGSettingsView: UIView {
    
    private let SETTINGS_VIEW_CELL_ID = "SV_ID"
    private var datas: Array<SettingsModel>!
    private var settingsAdapter: SettingsViewAdapter!
    
    private lazy var tableView: UITableView = self.createUITableView()
    
    enum SettingsType {
        /// A style with a "Right" signal
        case done
        /// A style with a right arrow.
        case enter
        /// A style with a UISwitch widget.
        case switchType
        /// Nothing.
        case blank
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implement.")
    }
    
    override var frame: CGRect{
        didSet{
            tableView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: frame.width,
                                     height: frame.height)
        }
    }
    
    override var backgroundColor: UIColor?{
        didSet{
            tableView.backgroundColor = backgroundColor ?? .white
        }
    }

}

// MARK: - Build
extension SGSettingsView {
    
    /**
     Fill a row with detail information.
     - Parameter text: Right content.
     - Parameter type: Cell type.
     - Parameter res: Optional resource content.
     -  Returns: Self to use chain method called.
     */
    @discardableResult
    public func fill(_ text: String, type: SettingsType, res: String?) -> Self{
        if datas == nil {
            datas = Array<SettingsModel>()
        }
        
        switch type {
        case .done:
            datas.append(SettingsModel(text: text, type: .done, res: res))
        case .enter:
            datas.append(SettingsModel(text: text, type: .enter, res: res))
        case .switchType:
            datas.append(SettingsModel(text: text, type: .switchType, res: res))
        case .blank:
            datas.append(SettingsModel(text: text, type: .blank, res: res))
        }
        
        return self
    }
    
    /**
     When method of `fill` was called ended then called this method to build SGSettingsView.
     */
    @discardableResult
    public func builder() -> Self{
        settingsAdapter = SettingsViewAdapter(datas: datas, id: getId())
        tableView.delegate = settingsAdapter
        tableView.dataSource = settingsAdapter
        self.layer.masksToBounds = true
        self.addSubview(tableView)
        
        return self
    }
    
    /**
     Accroing to cells count to return final height for SGSettingsView.
     */
    public func getFinalHeight() -> CGFloat{
        return CGFloat(datas.count * 44)
    }
    
    public func setCellWithSwitchStatus(at index: Int, status: Bool){
        for (idx, model) in self.datas.enumerated() {
            if (idx == index) {
                model.isSwitchEnable = status
            }
        }
        self.settingsAdapter.updateDatas(datas: self.datas)
        self.tableView.reloadData()
    }
    
    /**
     Set click listener for SGSettingView.
     - Parameter listener: Callback closure. `index` used for detemine which one is selected. `status` used for detemine which one is turn on or off. (It's optional)
     */
    public func setOnSettingsClickListener(_ listener: ((_ index: Int, _ status: Bool?) -> Void)?){
        settingsAdapter.cellClickAction = { (index, status) in
            listener?(index, status)
            self.updateView(index)
        }
    }
    
    public func setOnSettingsUpdateEvent(_ index: Int){
        updateView(index)
    }
    
    private func updateView(_ index: Int){
        var isUpdateForDone: Bool = false
        
        // Iterate the model that the cell accessView's type is `.done` or `.blank` only.
        for model in self.datas {
            if model.type == .done || model.type == .blank{
                isUpdateForDone = true
            } else {
                isUpdateForDone = false
            }
        }
        
        if isUpdateForDone {

            for (idx, model) in self.datas.enumerated() {
                (index == idx) ? (model.type = .done) : (model.type = .blank)
            }

            self.settingsAdapter.updateDatas(datas: self.datas)
            self.tableView.reloadData()
        }
        
    }
    
}

// MARK: - View
extension SGSettingsView {
    
    fileprivate func createUITableView() -> UITableView{
        let tableView = UITableView()
        tableView.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: getId())
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }
    
    fileprivate func getId() -> String{
        return "\(SETTINGS_VIEW_CELL_ID)_\(String(self.hashValue).suffix(6))"
    }
    
}

extension UITableViewCell {
    
    func setSGSettingsCell(model: SettingsModel){
        switch model.type {
        case .done:
            accessoryType = .checkmark
        case .enter:
            accessoryType = .disclosureIndicator
        case .switchType:
            let uiSwitch = UISwitch()
            uiSwitch.isOn = model.isSwitchEnable
            accessoryView = uiSwitch
        case .blank:
            accessoryType = .none
        case .none:
            break
        }
        
        if model.type == .done {
            self.textLabel?.textColor = .systemBlue
        }
    }
    
}
