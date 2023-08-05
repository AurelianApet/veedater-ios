//
//  CreditCardViewController.swift
//  VeeDaters
//
//  Created by Sachin Khosla on 01/01/18.
//  Copyright © 2018 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import Stripe
import ObjectMapper

class CreditCardViewController: UIViewController {
    
    @IBOutlet weak var cardNumberTxtFld: UITextField!
    @IBOutlet weak var cardHolderTxtFld: UITextField!
    @IBOutlet weak var cvvTxtFld: UITextField!
    @IBOutlet weak var monthTxtFld: BorderTextField!
    @IBOutlet weak var yearTxtFld: BorderTextField!

    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var duration = String()
    var price = String()

    var monthArr = [String]()
    var yearArr = [String]()
    
    var monthPicker = UIPickerView()
    var yearPicker = UIPickerView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        initialLoad()
        ExpireYear()
    }
}

//MARK:- Custom Function
//MARK:-
extension CreditCardViewController {
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "Complete Your Purchase", backTitle: "")
        
        monthArr = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        
        monthPicker.delegate = self
        yearPicker.delegate = self
        cardNumberTxtFld.delegate = self
        
        monthTxtFld.inputView = monthPicker
        yearTxtFld.inputView = yearPicker
        
        packagePriceLabel.text = "$\(price)/mo"
        durationLabel.text = "Membership for \(duration) month"
    }
    
    func ExpireYear() {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        for i in year..<2051 {
            let year = String(describing: i)
            self.yearArr.append(year)
        }
    }
    
    func stripeCreditCardValidate() {
        
        let year = yearTxtFld.text!.suffix(2)
        
        let cardParam = STPCardParams()
        cardParam.number = cardNumberTxtFld.text
        cardParam.expMonth = UInt((monthTxtFld.text! as NSString).integerValue)
        cardParam.expYear = UInt((year as NSString).integerValue)
        cardParam.cvc = cvvTxtFld.text!
        
        let stripCard = STPAPIClient()
        
        showProgressHUD()
        
        stripCard.createToken(withCard: cardParam) { (Token, error) in
            self.hideProgressHUD()
            if Token == nil {
                self.showAlert(message: "Please enter valid detail")
            } else {
              
                if let token = Token?.tokenId {
                    
                    var param = [String:Any]()

                    if self.duration == "one" {
                        param["User[months]"] = "1"
                    } else if self.duration == "three" {
                        param["User[months]"] = "3"
                    } else if self.duration == "six" {
                        param["User[months]"] = "6"
                    }
                    param["User[token]"] = token
                    
                    self.servicePayment(parameter: param)
                }
            }
        }
    }
    
    func successAlert() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        let controller =  ScreenManager.getPaymentSuccessViewController()
        controller.price = price
        self.addChildViewController(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
}

//MARK:- Button Action
//MARK:-
extension CreditCardViewController {
    
    @IBAction func tapMakePayment(_ sender: UIButton) {
        if (cardNumberTxtFld.text?.isEmpty)! {
            showAlert(message: "Please enter card number")
        } else if (cardHolderTxtFld.text?.isEmpty)! {
            showAlert(message: "Please enter cardholder name")
        } else if (monthTxtFld.text?.isEmpty)! {
            showAlert(message: "Please enter end month")
        } else if (yearTxtFld.text?.isEmpty)! {
            showAlert(message: "Please enter end year")
        } else if (cvvTxtFld.text?.isEmpty)! {
            showAlert(message: "Please enter cvv number")
        } else {
            stripeCreditCardValidate()
        }
    }
}


//MARK:- Picker Data Source
//MARK:-
extension CreditCardViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if monthPicker == pickerView {
            return monthArr.count
        } else {
            return yearArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if monthPicker == pickerView {
            return monthArr[row]
        } else {
            return yearArr[row]
        }
    }
}

//MARK:- Picker Delegate
//MARK:-
extension CreditCardViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if monthPicker == pickerView {
            monthTxtFld.text =  monthArr[row]
        } else {
            yearTxtFld.text = yearArr[row]
        }
    }
}


//MARK:- UITextFieldDelegate
//MARK:-
extension CreditCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNumberTxtFld && cardNumberTxtFld.text?.count == 16 && string.count > 0 {
            return false
        } else  if textField == cvvTxtFld && cvvTxtFld.text?.count == 4 && string.count > 0 {
            return false
        }
        return true
    }
}

//MARK:- Web Services
//MARK:-
extension CreditCardViewController {
 
    func servicePayment(parameter:[String:Any]) {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.makePayment, method: .post, parameters:parameter,completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            
            if let json = jsonData as? [String:Any] {
                
                if let subscriptionModel = Mapper<SubscriptionModel>().map(JSONObject: json["subscription"]) {
                    
                    if let userDetail = UserDefaults.getUser() {
                        userDetail.subscription = subscriptionModel
                        UserDefaults.setUser(userDetail)
                        self.successAlert()
                    }
                }
            }
            
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}

