//
//  PackagesViewController.swift
//  VeeDaters
//
//  Created by Sachin Khosla on 01/01/18.
//  Copyright © 2018 Rishabh Wadhwa. All rights reserved.
//

import UIKit

class PackagesViewController: UIViewController {
    
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var packagesPrice = ["24.99","19.99","14.99"]
    var packagesDuration = ["one","three","six"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isTabBarShow()
    }
}

//MARK:- Custom Function
//MARK:-
extension PackagesViewController {
    
    func  initialLoad() {
        
        navigationBarTitle(headerTitle: "Choose Payment Plans", backTitle: "")
    }
    
    func configureTableView() {
        
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = (self.view.bounds.height - 154) / 3
        
        let cell = UINib(nibName: PackageTableViewCell.className, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: PackageTableViewCell.className)
        
    }
}

//MARK:- Button Action
//MARK:-
extension PackagesViewController {
    
    @IBAction func tappedBestOffer(_ sender: UIButton) {
        let controller = ScreenManager.getCreditCardViewController()
        controller.duration = packagesDuration[2]
        controller.price = packagesPrice[2]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
//MARK:-
extension PackagesViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packagesPrice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PackageTableViewCell.className, for: indexPath) as! PackageTableViewCell

        cell.durationLabel.text = "For \(packagesDuration[indexPath.row]) month"
        cell.priceLabel.text = "$\(packagesPrice[indexPath.row])/mo"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ScreenManager.getCreditCardViewController()
        controller.duration = packagesDuration[indexPath.row]
        controller.price = packagesPrice[indexPath.row]

        self.navigationController?.pushViewController(controller, animated: true)
    }
}

