//
//  PreferenceCategoryViewController.swift
//  Veedater
//
//  Created by Sachin Khosla on 05/01/18.
//  Copyright © 2018 DigiMantra. All rights reserved.
//

protocol PreferenceCategoryViewControllerDelegate {
    func didFinishWithPreferneceCategoryViewController(filterModel:FilterModel,viewController:UIViewController)
}

import UIKit

class PreferenceCategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    var delegate:PreferenceCategoryViewControllerDelegate?
    
    var filterType = String()
    var filterArray = [String]()
    var selectedIndex = Int(-1)
    var filterModel = FilterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureTableView()
        configureBarItems()
    }
}

//MARK:- Custom Function
//MARK:-
extension PreferenceCategoryViewController {
    
    func  initialLoad() {
        
        navigationBarTitle(headerTitle: filterType, backTitle: "")
        
        headerTitleLabel.text = "Select"

        switch filterType {
        case App.Filter.gender:
            filterArray = genderArray
        case App.Filter.interestedGender:
            filterArray = showMeGenderArray
        case App.Filter.religion:
            filterArray = religionArray
        case App.Filter.sport:
            filterArray = sportsArray
        case App.Filter.income:
            filterArray = incomeArray
        case App.Filter.style:
            filterArray = fashionArray
        case App.Filter.martial:
            filterArray = martialArray
        case App.Filter.nation:
            filterArray = countries()
        default:
            break
        }
    }
    
    func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        
        let cell = UINib(nibName: PrefernceSelectedTableViewCell.className, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: PrefernceSelectedTableViewCell.className)
    }
    
    func configureBarItems() {
        
        let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedDone))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named:"whiteBack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedBack))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func getSelectedValue(index:Int)-> String? {
        
        var selectedValue = String()
        
        switch filterType {
        case App.Filter.gender:
            selectedValue = filterModel.gender ?? ""
        case App.Filter.interestedGender:
            selectedValue = filterModel.interestedGender ?? ""
        case App.Filter.religion:
            selectedValue = filterModel.religion ?? ""
        case App.Filter.sport:
            selectedValue = filterModel.sport ?? ""
        case App.Filter.income:
            
            let minIncome = filterModel.minIncome ?? ""
            let maxIncome = filterModel.maxIncome ?? ""
            
            if maxIncome.count > 0 {
                selectedValue = "$\(minIncome) - $\(maxIncome)"
            } else {
                selectedValue = "Above $\(minIncome)"
            }
            
        case App.Filter.style:
            selectedValue = filterModel.style ?? ""
        case App.Filter.martial:
            selectedValue = filterModel.martial ?? ""
        case App.Filter.nation:
            selectedValue = filterModel.nation ?? ""
        default:
            break
        }
        
        if filterArray[index] == selectedValue {
            return selectedValue
        }
        
        return nil
    }
}

//MARK:- Button Action
//MARK:-
extension PreferenceCategoryViewController {
    
    func tappedDone() {
        
        if selectedIndex == -1 {
            showAlert(message: "Plese select filter!")
            return
        }
        
        switch filterType {
            
        case App.Filter.gender:
            filterModel.gender = filterArray[selectedIndex]
        case App.Filter.interestedGender:
            filterModel.interestedGender = filterArray[selectedIndex]
        case App.Filter.religion:
            filterModel.religion = filterArray[selectedIndex]
        case App.Filter.sport:
            filterModel.sport = filterArray[selectedIndex]
        case App.Filter.income:
            
             var income = filterArray[selectedIndex]
             income = income.replacingOccurrences(of: "$", with: "")
             income = income.replacingOccurrences(of: " ", with: "")

             var incomeArr = income.components(separatedBy: "-")

             if income.contains("Above") {
                incomeArr = income.components(separatedBy: "Above")
                filterModel.minIncome = incomeArr[1]
                filterModel.maxIncome = ""
             } else {
                filterModel.minIncome = incomeArr[0]
                filterModel.maxIncome = incomeArr[1]
             }
            
        case App.Filter.style:
            filterModel.style = filterArray[selectedIndex]
            
        case App.Filter.martial:
            filterModel.martial = filterArray[selectedIndex]
        case App.Filter.nation:
            filterModel.nation = filterArray[selectedIndex]

        default:
            break
        }
        
        delegate?.didFinishWithPreferneceCategoryViewController(filterModel: filterModel, viewController: self)
    }
    
    func tappedBack() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
//MARK:-
extension PreferenceCategoryViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrefernceSelectedTableViewCell.className, for: indexPath) as! PrefernceSelectedTableViewCell
        
        cell.titleLabel.text = filterArray[indexPath.row]
        
        if selectedIndex == -1 {
            
            if filterArray[indexPath.row] == getSelectedValue(index: indexPath.row) {
                selectedIndex = indexPath.row
                cell.tickImageView.image = UIImage(named:"tick")
            } else {
                cell.tickImageView.image = UIImage()
            }
            
        } else {
            
            if selectedIndex == indexPath.row {
                cell.tickImageView.image = UIImage(named:"tick")
            } else {
                cell.tickImageView.image = UIImage()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

