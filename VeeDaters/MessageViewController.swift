//
//  MessageViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 31/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//


import UIKit
import ObjectMapper

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    var messageList:[MessageModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        serviceGetChatUserList()
        isTabBarShow()
    }
}

//MARK:- Custom Function
//MARK:-
extension MessageViewController {
    
    func initialLoad() {
        navigationBarTitle(headerTitle: "Message", backTitle: "")
        self.placeholderLbl.text  = ""
    }
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100.0
        
        let cell = UINib(nibName: MessageTableViewCell.className, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: MessageTableViewCell.className)
    }
}


//MARK:- UITableViewDataSource, UITableViewDelegate
//MARK:-
extension MessageViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.className, for: indexPath) as! MessageTableViewCell
        
        if let messageList = messageList?[indexPath.row] {
            cell.configureCell(messageDetail: messageList)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = ScreenManager.getChatViewController()
        
        if let messageDetail = messageList?[indexPath.item] {
            
            anotherUserModel = UserModel()
            
            if messageDetail.senderID  == UserDefaults.getUser()?.id {
                
                anotherUserModel?.id = messageDetail.receiverID
                anotherUserModel?.username = messageDetail.receiverName
                anotherUserModel?.chatUserImage = messageDetail.receiverImage
                
            } else {
                
                anotherUserModel?.id = messageDetail.senderID
                anotherUserModel?.username = messageDetail.senderName
                anotherUserModel?.chatUserImage = messageDetail.senderImage
            }
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            
            var param = [String:Any]()
            if self.messageList?[indexPath.row].senderID == UserDefaults.getUser()?.id {
                param["Message[user_id]"] = self.messageList?[indexPath.row].receiverID
            } else {
                param["Message[user_id]"] = self.messageList?[indexPath.row].senderID
            }
            self.serviceDeleteUser(param:param)
        }
        
        return [deleteButton]
    }
}


//MARK:- Web Service
//MARK:-
extension MessageViewController {
    
    func serviceGetChatUserList() {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.getUsersMessageList, method: .get, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            
            if let json = jsonData as? [String:Any] {
                
                self.messageList = nil
                
                if let messageList = Mapper<MessageModel>().mapArray(JSONObject: json["list"]),messageList.count > 0 {
                    self.messageList = messageList
                     self.placeholderLbl.text  = ""
                } else {
                     self.placeholderLbl.text  = "No Messages Found"
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceDeleteUser(param:[String:Any]) {
        showProgressHUD()
                
        APIManager.shared.request(url: API.deleteUser, method: .post, parameters: param,  completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            self.showAlert(message: "User Delete")
            self.serviceGetChatUserList()
            self.tableView.reloadData()
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}
