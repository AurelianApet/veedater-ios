//
//  ChatViewController.swift
//  Chibha
//
//  Created by Sachin Khosla on 21/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var blockBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    var chatSubController = ScreenManager.getChatSubViewController()
    var userMessage:MessageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        viewStyling()
        popUpView.isHidden = true
        addChildController()
    }
}

//MARK:- Custom Functions
//MARK:-
extension ChatViewController {
    
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "Message", backTitle: "")
        
        let popup = UIBarButtonItem(image:UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style:.plain, target:self, action:#selector(popUpAlert(_:)))
        popup.tintColor = UIColor.clear
        navigationItem.rightBarButtonItems = [popup]
    }
    
    func viewStyling() {
        popUpView.backgroundColor = App.Colors.whiteBlue
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 1)
        popUpView.layer.shadowOpacity = 0.3
        popUpView.layer.cornerRadius = 3
        popUpView.layer.masksToBounds = false
    }
    
    func showSuccessAlert(message:String)  {
        
        let alertController = UIAlertController(title: App.name, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addChildController() {
        
        let screenHeight = App.screenSize.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        
        let height = screenHeight - statusBarHeight - navigationBarHeight
        
        self.addChildViewController(chatSubController)
        chatSubController.view.frame = self.view.frame
        chatSubController.view.frame.origin.y =  screenHeight - height
        chatSubController.view.frame.size.height =  height
        self.view.addSubview(chatSubController.view)
        chatSubController.didMove(toParentViewController: self)
        
        self.view.addSubview(popUpView)
    }
}

//MARK:- Button Action
//MARK:-
extension ChatViewController {
    
    func popUpAlert(_ sender: UIBarButtonItem) {
        if popUpView.isHidden == true {
            popUpView.isHidden = false
        } else {
            popUpView.isHidden = true
        }
    }
    
    @IBAction func tapBlockBtn(_ sender: UIButton) {
        serviceBlockUser()
        popUpView.isHidden = true
    }
    
    @IBAction func tapClearChatBtn(_ sender: UIButton) {
        popUpView.isHidden = true
        chatSubController.serviceClearChat()
    }
}


//MARK:- Web Service
//MARK :-
extension ChatViewController {
    
    func serviceBlockUser() {
        showProgressHUD()
        
        var param = [String:Any]()
        param["User[user_id]"] = anotherUserModel?.id ?? ""
        
        APIManager.shared.request(url: API.blockUser, method: .post, parameters: param, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            self.showSuccessAlert(message: "Successfully user blocked")
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceDeleteUser(param:[String:Any]) {
        showProgressHUD()
        
        APIManager.shared.request(url: API.deleteUser, method: .post, parameters: param,  completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            self.showSuccessAlert(message: "Clear User Chat")
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}


