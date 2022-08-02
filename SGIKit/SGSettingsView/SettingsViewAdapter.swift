//
//  SettingsViewAdapter.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/1.
//

import UIKit

class SettingsViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var datas: Array<SettingsModel>!
    private var id: String!
    private var uiSwitchChangedAction: ((_ status: Bool) -> Void)?
    public var cellClickAction: ((_ index: Int, _ status: Bool?) -> Void)?
    
    init(datas: Array<SettingsModel>, id: String) {
        self.datas = datas
        self.id = id
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: id)
        
        switch datas[indexPath.row].type {
        case .done:
            cell.accessoryType = .disclosureIndicator
        case .enter:
            cell.accessoryType = .checkmark
        case .switchType:
            let uiSwitch = UISwitch()
   //         uiSwitch.addTarget(self, action: #selector(uiSwitchValueChangeListener(uiSwitch:)), for: .valueChanged)
            cell.accessoryView = uiSwitch
        case .blank:
            cell.accessoryType = .none
        case .none:
            break
        }
        
        cell.textLabel?.text = datas[indexPath.row].text
        if datas[indexPath.row].res != nil {
            cell.detailTextLabel?.text = datas[indexPath.row].res!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellClickAction != nil {
            switch datas[indexPath.row].type {
            case .done:
                cellClickAction!(indexPath.row, nil)
            case .enter:
                cellClickAction!(indexPath.row, nil)
            case .switchType:
                let cell = tableView.cellForRow(at: indexPath)
                let uiSwitch = cell?.accessoryView as? UISwitch
                uiSwitch?.addTarget(self, action: #selector(uiSwitchValueChangeListener(uiSwitch:)), for: .valueChanged)
                uiSwitchChangedAction = { (status) in
                    self.cellClickAction!(indexPath.row, status)
                }
            case .blank:
                cellClickAction!(indexPath.row, nil)
            case .none:
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func uiSwitchValueChangeListener(uiSwitch: UISwitch){
        if uiSwitchChangedAction != nil {
            uiSwitchChangedAction!(uiSwitch.isOn)
        }
    }

}
