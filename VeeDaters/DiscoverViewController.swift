//
//  DiscoverViewController.swift
//  veeDaters
//
//  Created by Rishabh Wadhwa on 30/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import ObjectMapper

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    var userList:[UserModel]?
    var filterModel = FilterModel()

    override func viewWillAppear(_ animated: Bool) {
        initialLoad()
        configureCollectionView()
        serviceGetUserList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if tabBarController?.selectedIndex != 2 {
            filterModel = FilterModel()
        }
    }
}

//MARK:- Custom Function
//MARK:-
extension DiscoverViewController {
    
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "VSearch", backTitle: "")
        
        let filterButtton = UIBarButtonItem(image: UIImage(named: "filter"),  style: .plain, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItems = [filterButtton]
    }
    
    func configureCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cell = UINib(nibName: DiscoverCollectionViewCell.className, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: DiscoverCollectionViewCell.className)
    }
}

//MARK:- Button Action
//MARK:-
extension DiscoverViewController {
    
    func filterTapped() {
        let controller = ScreenManager.getFilterViewController()
        controller.delegate = self
        controller.filterModel = self.filterModel
        
        let navController = ScreenManager.getCustomNavigationBarNavigationController(controller)
        self.present(navController, animated: true, completion: nil)
    }
}

//MARK:- CollectionView DateSource,Delegate & FlowLayoutDelegate
//MARK:-
extension DiscoverViewController : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.className, for: indexPath) as! DiscoverCollectionViewCell
        cell.delegate = self
        
        if let userDetail = userList?[indexPath.item] {
            cell.configureCell(userDetail: userDetail)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = ScreenManager.getAnotherProfileViewController()
        if let userDetail = userList?[indexPath.item] {
            anotherUserModel = userDetail
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK:- FilterViewControllerDelegate
//MARK:-
extension DiscoverViewController : FilterViewControllerDelegate {
    
    func didFinishFilterViewController(filterModel:FilterModel,controller:FilterViewController) {
        
        self.filterModel.age = filterModel.age
        self.filterModel.distance = filterModel.distance
        self.filterModel.gender = filterModel.gender
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- UserDetailCollectionViewCellDelegate
//MARK:-
extension DiscoverViewController : DiscoverCollectionViewCellDelegate {
    
    func didTapFavorite(cell: DiscoverCollectionViewCell) {
        
        if let indexPath =  collectionView.indexPath(for: cell) {
            
            var parameter = [String:Any]()
            parameter["User[user_id]"] = userList?[indexPath.item].id ?? ""
            
            if let likeStatus = userList?[indexPath.item].favourite {
                
                if likeStatus == 1 {
                    parameter["User[review]"] = "0"
                } else {
                    parameter["User[review]"] = "1"
                }
                
                serviceReviewUser(parameter: parameter)
            }
        }
    }
}


//MARK:- Web Service
//MARK:-
extension DiscoverViewController {
    
    func serviceGetUserList() {
        
        showProgressHUD()
        
        var parameter = [String:Any]()
        
        if filterModel.interestedGender == "All" {
            parameter["gender"] = ""
        } else {
            parameter["gender"] = filterModel.interestedGender ?? ""
        }
        
        parameter["lat"] = filterModel.latitude ?? ""
        parameter["lng"] = filterModel.longitude ?? ""
        parameter["age"] = filterModel.age ?? ""
        parameter["distance"] = filterModel.distance ?? ""
        
        APIManager.shared.request(url: API.getUserList, method: .get, parameters:parameter,completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            
            if let json = jsonData as? [String:Any] {
                
                self.userList = nil

                if let userList = Mapper<UserModel>().mapArray(JSONObject: json["user"]),userList.count > 0 {
                    self.userList = userList
                     self.placeholderLbl.text = ""
                } else {
                     self.placeholderLbl.text = "No User Found"
                }
                self.collectionView.reloadData()
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceReviewUser(parameter:[String:Any]) {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.userReview, method: .post, parameters:parameter,completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            
            if let _ = jsonData as? [String:Any] {
                self.serviceGetUserList()
            } 
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}

