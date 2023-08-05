//
//  BlockListViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 01/12/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import ObjectMapper

class BlockListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    var userList:[UserModel]?
    var selectIndexValue = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureCollectionView()
        serviceGetBlockedUser()
    }
}

//MARK:- Custom Function
//MARK:-
extension BlockListViewController {
    
    func  initialLoad() {
        navigationBarTitle(headerTitle: "Block List", backTitle: "")
        self.placeholderLbl.text  = ""
    }
    
    func configureCollectionView() {
        
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cell = UINib(nibName: DiscoverCollectionViewCell.className, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: DiscoverCollectionViewCell.className)
    }
    
    func showSuccessAlert(message:String)  {
        
        let alertController = UIAlertController(title: App.name, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.selectIndexValue.removeAll()
            self.serviceGetBlockedUser()
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK:- Button Action
//MARK:-
extension BlockListViewController {
    
    func unBlocktapped( _sender:UIButton) {
        if selectIndexValue.count > 0 {
            serviceUnBlockUser()
        }
    }
}

//MARK:- BlockListViewController, UITableViewDelegate
//MARK:-
extension BlockListViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.className, for: indexPath) as! DiscoverCollectionViewCell

        if let userDetail = userList?[indexPath.item] {
            cell.blockConfigureCell(userDetail: userDetail)
        }
        
        
        if selectIndexValue.contains(indexPath.item) {
            cell.favButton.setImage(UIImage(named:"unBlock") , for: .normal)
        } else {
            cell.favButton.setImage(UIImage(named:"block") , for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectIndexValue.contains(indexPath.item) {
            let index = selectIndexValue.index(of: indexPath.item)
            selectIndexValue.remove(at: index!)
        } else {
            selectIndexValue.append(indexPath.item)
        }
        
        if selectIndexValue.count > 0 {
            let unBlockBtn = UIBarButtonItem(title: "Unblock", style: .plain, target: self, action: #selector(unBlocktapped))
            navigationItem.rightBarButtonItems = [unBlockBtn]

        } else {
            let unBlockBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(unBlocktapped))
            navigationItem.rightBarButtonItems = [unBlockBtn]
        }
        
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 2 , height: collectionView.frame.size.width / 2)
    }
}

//MARK:- Web Service
//MARK:-
extension BlockListViewController {
    
    func serviceGetBlockedUser() {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.blockUserList, method: .get, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            
            if let json = jsonData as? [String:Any] {
                
                self.userList = nil

                if let userList = Mapper<UserModel>().mapArray(JSONObject: json["blocked_users"]),userList.count > 0 {
                    self.userList = userList
                     self.placeholderLbl.text = ""
                } else {
                     self.placeholderLbl.text  = "No Block User Found"
                }
                
                self.collectionView.reloadData()
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceUnBlockUser() {
        
        showProgressHUD()
        
        var param = [String:Any]()
        
        for (index,value) in selectIndexValue.enumerated() {
            param["User[user_id][\(index)]"] = userList?[value].id
        }
        
        APIManager.shared.request(url: API.userUnBlock, method: .post, parameters: param, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            self.showSuccessAlert(message:"Successfully user unblocked")
        }, failure: { (error) in
            self.showAlert(message: error)
        })
    }
}

