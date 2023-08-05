//
//  PreferencesViewController.swift
//  Veedater
//
//  Created by Sachin Khosla on 05/01/18.
//  Copyright © 2018 DigiMantra. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftRangeSlider

class PreferencesViewController: UIViewController {

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var religionLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    
    @IBOutlet weak var ageRangeSlider: RangeSlider!
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var alchohalSwitch: UISwitch!
    @IBOutlet weak var smokeSwitch: UISwitch!
    @IBOutlet weak var tattooSwitch: UISwitch!
    
    var filterModel = FilterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureSlider()
        configureBarItems()
        serviceGetPreferences()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ageRangeSlider.layoutIfNeeded()
        ageRangeSlider.updateLayerFramesAndPositions()
    }
}

//MARK:- Custom Function
//MARK:-
extension PreferencesViewController {
    
    func  initialLoad() {
        navigationBarTitle(headerTitle: "Filter", backTitle: "")
    }
    
    func configureSlider() {
        ageRangeSlider.knobTintColor = UIColor(patternImage: UIImage(named:"sliderThumb")!)
        distanceSlider.setThumbImage(UIImage(named:"sliderThumb"), for: .normal)
        
        ageLabel.text = "0 - 50"
        distanceLabel.text = "World wide"
        ageRangeSlider.lowerValue = 0
        ageRangeSlider.upperValue = 50
        distanceSlider.value = 250
        
        filterModel.distance = ""
        filterModel.minAge = "0"
        filterModel.maxAge = "50"
    }
    
    func configureBarItems() {
        
        let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedDone))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func updateComponenet() {
        
        genderLabel.text = self.filterModel.interestedGender ?? ""
        religionLabel.text = self.filterModel.religion ?? ""
        sportLabel.text = self.filterModel.sport ?? ""
        styleLabel.text = self.filterModel.style ?? ""
        
        if let minAge = filterModel.minAge, let maxAge = filterModel.maxAge, minAge.count > 0 , maxAge.count > 0  {
            ageRangeSlider.lowerValue = Double((minAge as NSString).floatValue)
            ageRangeSlider.upperValue = Double((maxAge as NSString).floatValue)
            ageLabel.text = "\(minAge) - \(maxAge)"
        }
        
        if let distance = filterModel.distance,distance.count > 0 {
            
            distanceSlider.value = (distance as NSString).floatValue

            if distance == "World wide" {
                distanceLabel.text = distance
            } else {
                distanceLabel.text = "\(distance) mi"
            }
        }
        
        let minIncome = filterModel.minIncome ?? ""
        let maxIncome = filterModel.maxIncome ?? ""
        
        if maxIncome.count > 0 {
            incomeLabel.text = "$\(minIncome) - $\(maxIncome)"
        } else if minIncome.count > 0 {
            incomeLabel.text = "Above $\(minIncome)"
        }
        
        alchohalSwitch.isOn = filterModel.alchohal == "yes" ? true:false
        smokeSwitch.isOn = filterModel.smoke == "yes" ? true:false
        tattooSwitch.isOn = filterModel.tattoo == "yes" ? true:false
        
    }
}

//MARK:- Button Action
//MARK:-
extension PreferencesViewController {
    
    func tappedDone() {
        
        var param = [String:Any]()
        
        if filterModel.interestedGender == "All" {
            param["User[gender]"] = ""
        } else {
            param["User[gender]"] = filterModel.interestedGender ?? ""
        }
        
        param["User[min_age]"] = filterModel.minAge ?? ""
        param["User[max_age]"] = filterModel.maxAge ?? ""
        param["User[distance]"] = filterModel.distance ?? ""
        param["User[religion]"] = filterModel.religion ?? ""
        param["User[sports]"] = filterModel.sport ?? ""
        param["User[min_income]"] = filterModel.minIncome ?? ""
        param["User[max_income]"] = filterModel.maxIncome ?? ""
        param["User[style]"] = filterModel.style ?? ""
        param["User[alchohol]"] = filterModel.alchohal ?? ""
        param["User[smoke]"] = filterModel.smoke ?? ""
        param["User[tatoo]"] = filterModel.tattoo ?? ""
        
        serviceSavePreferences(param: param)
    }
    
    @IBAction func ageSlider(_ sender: RangeSlider) {
        ageLabel.text = "\(Int(sender.lowerValue)) - \(Int(sender.upperValue))"
        filterModel.minAge = "\(Int(sender.lowerValue))"
        filterModel.maxAge = "\(Int(sender.upperValue))"
    }
    
    @IBAction func distanceSlider(_ sender: UISlider) {
        
        if sender.value > 249 {
            distanceLabel.text = "World wide"
            filterModel.distance = ""
        } else {
            distanceLabel.text = "\(Int(sender.value))"
            filterModel.distance = "\(Int(sender.value))"
        }
    }
    
    
    @IBAction func tappedSwitch(_ sender: UISwitch) {
        
        if sender.tag == 1 { // Alchohal
            filterModel.alchohal = sender.isOn == true ? "yes" : "no"
        } else if sender.tag == 2 { // smoke
            filterModel.smoke = sender.isOn == true ? "yes" : "no"
        } else if sender.tag == 3 { // Tattoo
            filterModel.tattoo = sender.isOn == true ? "yes" : "no"
        }
    }
    
    
    @IBAction func tappedFilter(_ sender: UIButton) {
        
        let controller = ScreenManager.getPreferenceCategoryViewController()
        controller.delegate = self

        if sender.tag == 1 { // Interseted gender
            controller.filterType = App.Filter.interestedGender

        } else if sender.tag == 2 { // Religion
            controller.filterType = App.Filter.religion

        } else if sender.tag == 3 { // Sport
            controller.filterType = App.Filter.sport

        } else if sender.tag == 4 { // Income
            controller.filterType = App.Filter.income

        } else if sender.tag == 5 { // Style
            controller.filterType = App.Filter.style
            
        }
        
        controller.filterModel = self.filterModel
        
        let navController = ScreenManager.getCustomNavigationBarNavigationController(controller)
        present(navController, animated: true, completion: nil)
    }
}

//MARK:- PreferenceCategoryViewControllerDelegate
//MARK:-
extension PreferencesViewController:PreferenceCategoryViewControllerDelegate {
    
    func didFinishWithPreferneceCategoryViewController(filterModel: FilterModel, viewController: UIViewController) {
        self.filterModel = filterModel
        
        updateComponenet()

        dismiss(animated: true, completion: nil)
    }
}

//MARK:- WebServices
//MARK:-
extension PreferencesViewController {
    
    func serviceSavePreferences(param:[String:Any]) {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.preferences, method: .post, parameters:param,completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            if let _ = jsonData as? [String:Any] {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceGetPreferences() {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.preferences, method: .get, parameters:nil,completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            if let json = jsonData as? [String:Any] {
                
                if let filterModel = Mapper<FilterModel>().map(JSONObject: json["user"]) {

                    self.filterModel = filterModel
                    self.updateComponenet()
                }
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
}
