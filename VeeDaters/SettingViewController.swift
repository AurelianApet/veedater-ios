//
//  SettingViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 01/12/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureTableView()
    }
}

//MARK:- Custom Function
//MARK:-
extension SettingViewController {
    func  initialLoad() {
        
        navigationBarTitle(headerTitle: "Setting", backTitle: "")
        settingList = ["Favorites", "Block List","Preferences","Change Password"]    }
    
    func configureTableView() {
        
        tableView.tableFooterView = UIView()
        
        let cell = UINib(nibName: PrefernceSelectedTableViewCell.className, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: PrefernceSelectedTableViewCell.className)
        
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
//MARK:-
extension SettingViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrefernceSelectedTableViewCell.className, for: indexPath) as! PrefernceSelectedTableViewCell
        
        cell.titleLabel.text = settingList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let controller = ScreenManager.getFavoriteViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 1 {
            let controller = ScreenManager.getBlockListViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 2 {
            let controller = ScreenManager.getPreferencesViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 3 {
            let controller = ScreenManager.getChangePasswordViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
