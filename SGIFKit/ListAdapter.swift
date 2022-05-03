//
//  ListAdapter.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/2.
//

import UIKit

class ListAdapter: NSObject, UITableViewDelegate, UITableViewDataSource{

    var datas: Array<ListModel>!
    
    var listener: ((_ select: Int) -> Void)?
    
    init(datas: Array<ListModel>){
        self.datas = datas
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "IF_LIST", for: indexPath)
        cell = UITableViewCell(style: .default, reuseIdentifier: "IF_LIST")

        switch judgeDataSourceType(data: self.datas){
        case .Image:
            cell.imageView?.image = UIImage(named: self.datas[indexPath.row].data1)
        case .Text:
            cell.textLabel?.text = self.datas[indexPath.row].data1
        case .ImageAndText:
            cell.imageView?.image = UIImage(named: self.datas[indexPath.row].data1)
            cell.detailTextLabel?.text = self.datas[indexPath.row].data2
        case .TextAndImage:
            cell.textLabel?.text = self.datas[indexPath.row].data1
            cell.imageView?.image = UIImage(named: self.datas[indexPath.row].data2)
        case .None:
            Log.debug("None")
        default:
            Log.debug("Default")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener!(indexPath.row)
    }
}

extension ListAdapter{
    
    enum CellShowType {
        case Text
        case Image
        case TextAndImage
        case ImageAndText
        case None
    }
    
    fileprivate func judgeDataSourceType(data: Array<ListModel>) -> CellShowType{
        let poinner: ListModel = data[0]
        
        if imageIsExist(poinner.data1) && poinner.data2 == ""{
            return .Image
        }
        if poinner.data1 != "" && poinner.data2 == ""{
            return .Text
        }
        if imageIsExist(poinner.data1) && !imageIsExist(poinner.data2) && poinner.data2 != ""{
            return .ImageAndText
        }
        if poinner.data1 != "" && !imageIsExist(poinner.data1) && imageIsExist(poinner.data2){
            return .TextAndImage
        }
        if poinner.data1 == "" && poinner.data2 == "" {
            return .None
        }
        
        return .None
    }
    
    fileprivate func imageIsExist(_ name: String) -> Bool{
        let image = UIImage(named: name)
        
        if image?.size != nil {
            return true
        }
        
        return false
    }
    
}
