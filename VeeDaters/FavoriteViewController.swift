//
//  FavoriteViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 31/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import ObjectMapper

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    var userList:[UserModel]?
    var selectIndexValue = [Int]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initialLoad()
        configureCollectionView()
        serviceGetFavList()
    }
}

//MARK:- Custom Function
//MARK:-
extension FavoriteViewController {
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "Favorite", backTitle: "")
        self.placeholderLbl.text  = ""
    }
    
    func configureCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cell = UINib(nibName: DiscoverCollectionViewCell.className, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: DiscoverCollectionViewCell.className)
    }
}


//MARK:- CollectionView DateSource,Delegate & FlowLayoutDelegate
//MARK:-
extension FavoriteViewController : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
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

//MARK:- UserDetailCollectionViewCellDelegate
//MARK:-
extension FavoriteViewController : DiscoverCollectionViewCellDelegate {
    
    func didTapFavorite(cell: DiscoverCollectionViewCell) {
        
        if let indexPath =  collectionView.indexPath(for: cell) {
            
            var parameter = [String:Any]()
            parameter["User[user_id]"] = userList?[indexPath.item].id ?? ""
            parameter["User[review]"] = "0"
            serviceReviewUser(parameter: parameter)
        }
    }
}

//MARK:- Web Service
//MARK:-
extension FavoriteViewController{

    func serviceGetFavList() {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.favList, method: .get, parameters:nil,completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            
            if let json = jsonData as? [String:Any] {
                self.userList = nil

                if let userList = Mapper<UserModel>().mapArray(JSONObject: json["user"]),userList.count > 0 {
                    self.userList = userList
                     self.placeholderLbl.text  = ""
                } else {
                     self.placeholderLbl.text = "No Favorite User Found"
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
                self.serviceGetFavList()
            } 
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}
