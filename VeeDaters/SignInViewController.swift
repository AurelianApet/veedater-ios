//
//  SignInViewController.swift
//  veeDaters
//
//  Created by Rishabh Wadhwa on 30/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Google
import GoogleSignIn
import ObjectMapper

class SignInViewController: UIViewController , GIDSignInUIDelegate, GIDSignInDelegate{
    
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!

    var profileModel = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
}

//MARK:- Button Action
//MARK:-
extension SignInViewController {
    
    @IBAction func tapSignIn(_ sender: UIButton) {
        
        if userNameTxtFld.text!.isEmpty {
            showAlert(message: "Please enter Username")
        } else if passwordTxtFld.text!.isEmpty {
            showAlert(message: "Please enter password")
        } else {
            
            var param = [String:String]()
            param["User[username]"] = userNameTxtFld.text
            param["User[password]"] = passwordTxtFld.text!
            param["User[device_token]"] = UserDefaults.getDeviceToken() ?? ""
            param["User[device_type]"] = App.deviceType
            
            seviceUserLogin(params: param)
        }
    }
    
    @IBAction func tapFbLogin(_ sender: UIButton) {
        configureFacebookPermission()
    }
    
    @IBAction func tapGoogle(_ sender: UIButton) {
        configureGoogle()
    }
    
    @IBAction func tapSignUp(_ sender: UIButton) {
        let controller = ScreenManager.getSignUpViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func tapForgot(_ sender: UIButton) {
        let controller = ScreenManager.getForgotPasswordViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    

}

//MARK:- Custom Function
//MARK:-
extension SignInViewController {
    
    func initialLoad() {
        navigationBarTitle(headerTitle: "Sign in", backTitle: "")
    }
    
    func configureFacebookPermission() {
    
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil) {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    func getFBUserData() {
        
        if((FBSDKAccessToken.current()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil) {
                    
                    var dict : [String : AnyObject]!
                    dict = result as! [String : AnyObject]
                    var param = [String:String]()
                    param["User[social_id]"] = dict["id"] as? String
                    param["User[social_media_type]"] = "facebook"
                    param["User[username]"] = dict["name"] as? String
                    param["User[email]"] = dict["email"] as? String
                    param["User[device_token]"] = UserDefaults.getDeviceToken() ?? ""
                    param["User[device_type]"] = App.deviceType
                    
                    self.seviceUserLogin(params: param)
                }
            })
        }
    }
    
    func configureGoogle(){
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            let userId = user.userID
            let name = user.profile.name
            let email = user.profile.email
            
            var param = [String:String]()
            param["User[social_id]"] = userId!
            param["User[social_media_type]"] = "google"
            param["User[username]"] = name
            param["User[email]"] = email
            param["User[device_token]"] = UserDefaults.getDeviceToken() ?? ""
            param["User[device_type]"] = App.deviceType
            
            self.seviceUserLogin(params: param)

        }
    }
}

//MARK:- Web Service
//MARK:-
extension SignInViewController {
    
    func seviceUserLogin(params:[String:Any]) {
        showProgressHUD()
        
        APIManager.shared.request(url: API.login, method: .post, parameters: params, completionCallback: { (_) in
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
