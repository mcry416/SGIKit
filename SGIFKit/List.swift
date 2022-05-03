//
//  List.swift
//  Compent
//
//  Created by Eldest's MacBook on 2022/5/1.
//

import UIKit

extension UIViewController{
    
    @discardableResult
    func List(data: Array<ListModel>,
              size: CGSize,
              itemListener: @escaping ((_ index: Int) -> Void)) -> UITableView{
        let tableView = self.createUITableView(size)
        let adapter = ListAdapter(datas: data)

        tableView.delegate = adapter
        tableView.dataSource = adapter
        
        adapter.listener = { (select) in
            itemListener(select)
        }
        
        return tableView
    }
    
    fileprivate func createUITableView(_ size: CGSize) -> UITableView{
        let rect: CGRect = CGRect(x: 0,
                                  y: 0,
                                  width: size.width,
                                  height: size.height)
        let tableView = UITableView(frame: rect)
        tableView.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "IF_LIST")
        return tableView
    }
    
    
}
