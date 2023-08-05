//
//  ForgetPasswordViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 07/11/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTxtFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
}


//MARK:- Custom Function
//MARK:-
extension ForgotPasswordViewController {
    func initialLoad() {
        navigationBarTitle(headerTitle: "Forgot Password", backTitle: "")
    }
    
    func showSuccessAlert()  {
        
        let alertController = UIAlertController(title: App.name, message: "Your password has been reset successfully! Your new password has been sent to your primary email address.", preferredStyle: .alert)
        
        let done = UIAlertAction(title: "Ok", style: .default) { (alert) in
            UserDefaults.clearAllKeysData()
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(done)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK:- Button Action
//MARK:-
extension ForgotPasswordViewController {
    
    @IBAction func tapSend(_ sender: UIButton) {
        
        if emailTxtFld.text!.isEmpty {
            showAlert(message: "Please enter emailid")
        }  else if isValidEmail(email: emailTxtFld.text!) == false {
            showAlert(message: "Please enter valid emailid")
        } else {
            
            var param = [String:String]()
            param["User[email]"] = emailTxtFld.text
            serviceForgotPassword(param: param)
        }
    }
    
    @IBAction func tapSignUp(_ sender: UIButton) {
        let controller = ScreenManager.getSignUpViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK:- WebService
//MARK:-
extension ForgotPasswordViewController {
    
    func serviceForgotPassword(param:[String:Any]) {
        showProgressHUD()
        
        APIManager.shared.request(url: API.forgotPassword, method: .post, parameters: param, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            self.showSuccessAlert()
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}



