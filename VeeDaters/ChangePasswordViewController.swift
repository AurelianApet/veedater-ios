//
//  ChangePasswordViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 19/01/18.
//  Copyright © 2018 Rishabh Wadhwa. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTxtFld: UITextField!
    @IBOutlet weak var newPasswordtxtFld: UITextField!
    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
}

//MARK:- Custom Function
//MARK:-
extension ChangePasswordViewController {
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "Change Password", backTitle: "")
        
        let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

//MARK:- Button Action
//MARK:-
extension ChangePasswordViewController {
    
    func doneTapped() {
        
        if oldPasswordTxtFld.text!.isEmpty {
            showAlert(message: "Please enter old password")
        } else if newPasswordtxtFld.text!.isEmpty{
            showAlert(message: "Please enter new password")
        } else if confirmPasswordTxtFld.text!.isEmpty {
            showAlert(message: "Please re-enter new password")
        } else if newPasswordtxtFld.text != confirmPasswordTxtFld.text  {
            showAlert(message: "Password does not match")
        } else {
            showAlert(message: "Successfully changed password")
            oldPasswordTxtFld.text = ""
            newPasswordtxtFld.text = ""
            confirmPasswordTxtFld.text = ""
        }
    }
}
