//
//  ViewControllerExtension.swift
//  Chibha
//
//  Created by Sachin Khosla on 12/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//
import UIKit
import Foundation
import MBProgressHUD

fileprivate var tabbarSelectedImageView = UIImageView()
fileprivate var tabbarSelectedIndex = Int()
private var progressHUD: MBProgressHUD?


extension UIViewController {
    
    func navigationBarTitle(headerTitle:String = "", backTitle backtitle:String = "") {
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: backtitle, style: .plain, target: nil, action: nil)
        title = headerTitle

        isTabBarShow()
    }
 
    
    func showNavigationOrTabbar() {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func hideNavigationOrTabbar(){
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- Validations
    //MARK:-
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    //MARK:- Alerts
    //MARK:-
    
    func showAlert(message:String)  {
        
        let alertController = UIAlertController(title: App.name, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(error:Error)  {
        
        let alertController = UIAlertController(title: App.name, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func facebookVerificationAlert()  {
        
        let alertController = UIAlertController(title: App.name, message: "Successfully Login With Facebook", preferredStyle: .alert)
        let done = UIAlertAction(title: "Ok", style: .default) { (alert) in
            UserDefaults.clearAllKeysData()
            UserDefaults.standard.set(true, forKey: "userLogin")
            ScreenManager.setAsMainViewController(ScreenManager.getTabbarWIthItems())
        }
        
        alertController.addAction(done)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func googleVerificationAlert()  {
        
        let alertController = UIAlertController(title: App.name, message: "Successfully Login With Gmail", preferredStyle: .alert)
        let done = UIAlertAction(title: "Ok", style: .default) { (alert) in
            UserDefaults.clearAllKeysData()
            UserDefaults.standard.set(true, forKey: "userLogin")
            ScreenManager.setAsMainViewController(ScreenManager.getTabbarWIthItems())
        }
        alertController.addAction(done)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:- MBProgreddHUD
    //MARK:-
    
    func showProgressHUD(message:String? = nil) {
        view.endEditing(true)
        
        progressHUD = nil
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        
        if let message = message {
            progressHUD?.label.text = message
        }
    }
    
    func hideProgressHUD() {
        if let progressHUD = progressHUD {
            progressHUD.hide(animated: true)
        }
    }
    
    //MARK:- Tabbar Functions
    //MARK:-
    
    func isTabBarShow() {
        
        if self.className == ChatViewController.className || self.className == ChatSubViewController.className || self.className == SignInViewController.className || self.className == PackagesViewController.className || self.className == CreditCardViewController.className {
            navigationController?.isNavigationBarHidden = false
            tabBarController?.tabBar.isHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    func replaceTabbarRootViewController(controller:UIViewController) {
        
        if let navController = tabBarController?.viewControllers?[3] as? UINavigationController {
            navController.viewControllers.removeAll()
            navController.viewControllers = [controller]
            tabBarController?.viewControllers?[3] =  navController
        }
    }
    
    //PopToSpecificController
    func popToSpecificController(viewController:UIViewController? = nil) {
        
        if let viewControllers = self.navigationController?.viewControllers
        {
            if let popController = viewController {
                for (index,controller) in viewControllers.enumerated()
                {
                    if controller.className == popController.className {
                        navigationController?.popToViewController(viewControllers[index], animated: true)
                        break
                    }
                }
            } else {
                navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
            }
        }
    }
}

//MARK:- UITabBarDelegate
//MARK:-
extension UIViewController:UITabBarDelegate {
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.hideProgressHUD()
    }
}


