//
//  FilterViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 31/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import SwiftRangeSlider

protocol FilterViewControllerDelegate:NSObjectProtocol {
    func didFinishFilterViewController(filterModel:FilterModel,controller:FilterViewController)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var ageSlider: RangeSlider!
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    var filterModel = FilterModel()
    var delegate:FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureBarItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ageSlider.layoutIfNeeded()
        ageSlider.updateLayerFramesAndPositions()
    }
}

//MARK:- Custom Function
//MARK:-
extension FilterViewController {
    
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "Filter", backTitle: "Nearby")

        ageSlider.knobTintColor = UIColor(patternImage: UIImage(named:"sliderThumb")!)
        distanceSlider.setThumbImage(UIImage(named:"sliderThumb"), for: .normal)
        
        updateFilter()
    }
    
    func updateFilter() {
        
        if let interestedGender = filterModel.interestedGender {
            genderLabel.text = interestedGender
        } else {
            genderLabel.text = "All"
            filterModel.interestedGender = "All"
        }
        

        if let age = filterModel.age {
            
            let ageSeperate = age.components(separatedBy: "-")
            ageSlider.lowerValue = Double((ageSeperate[0] as NSString).floatValue)
            ageSlider.upperValue = Double((ageSeperate[1] as NSString).floatValue)
            ageLabel.text = age
            
        } else {
            
            ageSlider.lowerValue = 10
            ageSlider.upperValue = 40
            ageLabel.text = "10 - 40"
        }
        
        if let distance = filterModel.distance,distance.count > 0 {
            
            distanceSlider.value = (distance as NSString).floatValue
            distanceLabel.text = "\(distance) mi"
        } else {
            distanceLabel.text = "World wide"
            distanceSlider.value = 250.0
        }
    }
    
    func configureBarItems() {
        
        let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedDone))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

//MARK:- Button Action
//MARK:-
extension FilterViewController {
    
    func tappedDone() {
        
        filterModel.interestedGender = genderLabel.text
        
        if let age = ageLabel.text {
            filterModel.age = age
        }
        
        if var distance = distanceLabel.text {
            if distance == "World wide" {
                filterModel.distance = ""
            } else {
                let seperateDistance = distance.components(separatedBy: "mi")
                distance = seperateDistance[0]
                filterModel.distance = distance
            }
        }
        
        delegate?.didFinishFilterViewController(filterModel: filterModel, controller: self)
    }
    
    
    @IBAction func tappedGender(_ sender: UIButton) {
        
        let controller = ScreenManager.getPreferenceCategoryViewController()
        controller.delegate = self
        controller.filterType = App.Filter.interestedGender
        controller.filterModel = self.filterModel
        
        let navController = ScreenManager.getCustomNavigationBarNavigationController(controller)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func ageSlider(_ sender: RangeSlider) {
        ageLabel.text = "\(Int(sender.lowerValue)) - \(Int(sender.upperValue))"
    }
    
    @IBAction func distanceSlider(_ sender: UISlider) {
        let distanceValue = Int(sender.value)
        distanceLabel.text = "\(distanceValue) mi"
        
        if distanceLabel.text == "250 mi" {
            distanceLabel.text = "World wide"
        }
    }
}

//MARK:- PreferenceCategoryViewControllerDelegate
//MARK:-
extension FilterViewController:PreferenceCategoryViewControllerDelegate {
    
    func didFinishWithPreferneceCategoryViewController(filterModel: FilterModel, viewController: UIViewController) {
        self.filterModel = filterModel
        genderLabel.text = self.filterModel.interestedGender ?? ""
        dismiss(animated: true, completion: nil)
    }
}

