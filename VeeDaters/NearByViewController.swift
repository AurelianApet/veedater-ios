//
//  NearByViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 31/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//
import UIKit
import GoogleSignIn
import ObjectMapper
import CoreLocation
import Jelly


class NearByViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    public var collectionViewLayout: LGHorizontalLinearFlowLayout!
    
    var userList:[UserModel]?
    var filterModel = FilterModel()
    let locationManager = CLLocationManager()
    var isFetchCoordinate = Bool(false)
    var jellyAnimator: JellyAnimator?


    public var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    public var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarTitle(headerTitle: "Near by", backTitle: "")
        configureCoreLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if tabBarController?.selectedIndex != 0 {
            filterModel = FilterModel()
        }
    }
}

//MARK:- Custom Function
//MARK:-
extension NearByViewController {
    
    func initialLoad() {
        let filterButtton = UIBarButtonItem(image: UIImage(named: "filter"),  style: .plain, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItems = [filterButtton]
        
        self.placeholderLbl.text = "No User Found"
    }
    
    func configureCollectionView() {
        
        let cell = UINib(nibName: UserDetailCollectionViewCell.className, bundle: nil)
        self.collectionView.register(cell, forCellWithReuseIdentifier: UserDetailCollectionViewCell.className)
        
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height) , minimumLineSpacing: 0 )
    }

    func configureCoreLocation() {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                
                
                let alertController = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app.", preferredStyle: .alert)
                
                let settingAction = UIAlertAction(title: "Setting", style: .default, handler: { (_ ) in
                    
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                        if UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.openURL(appSettings)
                        }
                    }
                })
                
                let cancelAction = UIAlertAction(title: "cancel", style: .default,handler: nil)
                
                alertController.addAction(settingAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion:nil)

                
            case .authorizedAlways, .authorizedWhenInUse:
                isFetchCoordinate = false
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        } else {
            serviceGetUserList()
        }
    }
}

//MARK:- Button Action
//MARK:-
extension NearByViewController {
    
    func filterTapped() {
        
        let controller = ScreenManager.getFilterViewController()
        controller.delegate = self
        controller.filterModel = self.filterModel
        
        let navController = ScreenManager.getCustomNavigationBarNavigationController(controller)
        self.present(navController, animated: true, completion: nil)
    }
    
    func profileTapped(_ sender:UIButton) {
        
        let controller = ScreenManager.getAnotherProfileViewController()

        if let userDetail = userList?[sender.tag] {
            anotherUserModel = userDetail
        }

        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK:- CollectionView DateSource,Delegate & FlowLayoutDelegate
//MARK:-
extension NearByViewController : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserDetailCollectionViewCell.className, for: indexPath) as! UserDetailCollectionViewCell
        
        cell.delegate = self
        cell.profileButton.tag = indexPath.row
        cell.profileButton.addTarget(self, action: #selector(profileTapped(_:)), for: .touchUpInside)
        
        if let userDetail = userList?[indexPath.item] {
            cell.configureCell(userDetail: userDetail)
        }
        
        return cell
    }
}

//MARK:- CLLocationManagerDelegate
//MARK:-
extension NearByViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = locations.last?.coordinate
        
        if let latitude = coordinate?.latitude , let logitude = coordinate?.longitude {
            
            if isFetchCoordinate == false {
                locationManager.stopUpdatingLocation()
                isFetchCoordinate = true
                filterModel.latitude = "\(Float(latitude))"
                filterModel.longitude = "\(Float(logitude))"
                self.serviceGetUserList()
            }
        }
    }
}

//MARK:- FilterViewControllerDelegate
//MARK:-
extension NearByViewController : FilterViewControllerDelegate {
    func didFinishFilterViewController(filterModel:FilterModel,controller:FilterViewController) {
        
        self.filterModel.age = filterModel.age
        self.filterModel.distance = filterModel.distance
        self.filterModel.gender = filterModel.gender
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- UserDetailCollectionViewCellDelegate
//MARK:-
extension NearByViewController : UserDetailCollectionViewCellDelegate {
    
    func didTapFavorite(cell: UserDetailCollectionViewCell) {
        
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
extension NearByViewController {
    
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
