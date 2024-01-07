//
//  SettingsViewAdapter.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/1.
//

import UIKit

open class SettingsViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var datas: Array<SettingsModel>!
    private var id: String!
    private var uiSwitchChangedAction: ((Bool) -> Void)?
    public var cellClickAction: ((_ index: Int, _ status: Bool?) -> Void)?
    
    public init(datas: Array<SettingsModel>, id: String) {
        self.datas = datas
        self.id = id
    }
    
    open func updateDatas(datas: Array<SettingsModel>){
        self.datas.removeAll()
        self.datas = datas
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: id)
        
        cell.setSGSettingsCell(model: datas[indexPath.row]) { uiSwitch in
            uiSwitch.addTarget(self, action: #selector(SettingsViewAdapter.uiSwitchValueChangeListener(uiSwitch:)), for: .valueChanged)
        }
        
        cell.backgroundColor = KitColor.white1()
        cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        cell.textLabel?.text = datas[indexPath.row].text
        if datas[indexPath.row].res != nil {
            cell.detailTextLabel?.text = datas[indexPath.row].res!
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch datas[indexPath.row].type {
        case .done:
            cellClickAction?(indexPath.row, nil)
        case .enter:
            cellClickAction?(indexPath.row, nil)
        case .switchType:
            break
        case .blank:
            cellClickAction?(indexPath.row, nil)
        case .none:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    #warning("Waitting for repair the index getter.")
    @objc private func uiSwitchValueChangeListener(uiSwitch: UISwitch){
        guard let cell = uiSwitch.superview as? UITableViewCell else { return }
        guard let tableView = cell.superview as? UITableView else { return }
        guard let indexPath: IndexPath = tableView.indexPath(for: cell) else { return }
        self.cellClickAction?(indexPath.row, uiSwitch.isOn)
    }

}
