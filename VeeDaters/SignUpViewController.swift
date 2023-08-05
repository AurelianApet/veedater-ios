//
//  ViewController.swift
//  veeDaters
//
//  Created by Rishabh Wadhwa on 30/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import ObjectMapper

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNametxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
}

//MARK:- Custom Function
//MARK:-
extension SignUpViewController {
    func initialLoad() {
        navigationBarTitle(headerTitle: "Sign up", backTitle: "")
    }
}

//MARK:- Button Action
//MARK:-
extension SignUpViewController {
    
    @IBAction func tapSignUp(_ sender: UIButton) {
        
        if userNametxtFld.text!.isEmpty {
            showAlert(message: "Please enter Username")
        } else if emailTxtFld.text!.isEmpty{
            showAlert(message: "Please enter emailid")
        } else if isValidEmail(email: emailTxtFld.text!) == false {
            showAlert(message: "Please enter valid emailid")
        } else if passwordTxtFld.text!.isEmpty {
            showAlert(message: "Please enter password")
        } else {
            
            var param = [String:String]()
            param["User[email]"] = emailTxtFld.text!
            param["User[username]"] = userNametxtFld.text!
            param["User[password]"] = passwordTxtFld.text!
            param["User[device_token]"] = UserDefaults.getDeviceToken() ?? ""
            param["User[device_type]"] = App.deviceType
            serviceSignup(parameters: param)
        }
    }   
}


//MARK:- WebService
//MARK:-
extension SignUpViewController {
    
    func serviceSignup(parameters:[String:Any]) {
        showProgressHUD()
        
        APIManager.shared.request(url:API.signup, method: .post, parameters: parameters, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            
            if let json = jsonData as? [String:Any] {
                if let userModel = Mapper<UserModel>().map(JSONObject: json["user"]) {
                    UserDefaults.setUser(userModel)
                    ScreenManager.setAsMainViewController(ScreenManager.getTabbarWIthItems())
                }
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}

