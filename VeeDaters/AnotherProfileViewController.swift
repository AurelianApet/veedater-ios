//
//  AnotherProfileViewController.swift
//  VeeDaters
//
//  Created by Sachin Khosla on 22/12/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import ObjectMapper
import AVFoundation
import Kingfisher
import AVKit
import Jelly

class AnotherProfileViewController: UIViewController {
    
    @IBOutlet weak var basicView: UIView!
    @IBOutlet weak var advanceView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var birthDayTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var religionLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var alchohalSwitch: UISwitch!
    @IBOutlet weak var smokeSwitch: UISwitch!
    @IBOutlet weak var tattooSwitch: UISwitch!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTextViewHeight: NSLayoutConstraint!
    
    var userDetail:UserModel?
    var profileImages = [ProfileImageModel]()
    var avPlayer = AVPlayer()
    var isPopupOpen = Bool(false)

    
    override func viewWillAppear(_ animated: Bool) {
        
        if isPopupOpen == false || isMembershipPopupOpen == true {
            isMembershipPopupOpen = false
            isPopupOpen = false
            
            initialLoad()
            removeObserver()
            addPlayerObserver()
            configureBarItems()
            configureCollectionView()
            createGradientLayer()
            updateCollectionViewHeight()
            
            if let id = anotherUserModel?.id {
                serviceGetAnotherUserDetail(userID: id)
            }
        } else {
            initialLoad()
            playVideo()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isPopupOpen == false {
            stopVideo()
            removeObserver()
        }
    }
}

//MARK:- Custom Function
//MARK:-
extension AnotherProfileViewController {
    
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "Profile", backTitle: "")
        aboutMeTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4 , bottom: 0, right: 0)
        addressTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4 , bottom: 0, right: 0)
    }
    
    func configureBarItems() {
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"),  style: .plain, target: self, action: #selector(menuTapped))
        navigationItem.rightBarButtonItems = [rightBarButton]
    }
    
    func configureCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cell = UINib(nibName: AddImageCollectionViewCell.className, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: AddImageCollectionViewCell.className)
    }
    
    func updateCollectionViewHeight() {
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        collectionViewHeight.constant = CGFloat(collectionView.contentSize.height)
        collectionView.reloadData()
    }

    
    func updateProfileData() {
        
        if let user = userDetail {
            
            usernameTextField.text = user.username ?? ""
            
            if let dob = user.dob {
                let birthDate = DateTimeFormatter.convertToAppDateString(dateString: dob)
                birthDayTextField.text = birthDate
                ageButton.setTitle(user.age ?? "", for: .normal)
            }
            
            emailLabel.text = user.email ?? ""
            aboutMeTextView.text = user.about ?? ""
            addressTextView.text = user.address ?? ""
            
            nationLabel.text = user.nation ?? ""
            statusLabel.text = user.martial ?? ""
            genderLabel.text = user.gender ?? ""
            religionLabel.text = user.religion ?? ""
            sportLabel.text = user.sport ?? ""
            styleLabel.text = user.style ?? ""
            
            let minIncome = user.minIncome ?? ""
            let maxIncome = user.maxIncome ?? ""
            
            if maxIncome.count > 0 {
                incomeLabel.text = "$\(minIncome) - $\(maxIncome)"
            } else if minIncome.count > 0 {
                incomeLabel.text = "Above $\(minIncome)"
            }
            
            alchohalSwitch.isOn = user.alchohal == "yes" ? true:false
            smokeSwitch.isOn = user.smoke == "yes" ? true:false
            tattooSwitch.isOn = user.tattoo == "yes" ? true:false
            
            if let profileImages = user.profileImages {
                self.profileImages.removeAll()
                self.profileImages = profileImages
            } else {
                self.profileImages.removeAll()
            }
            
            collectionView.reloadData()
            
            
            if let loggedUser = UserDefaults.getUser() {
                if loggedUser.subscription == nil {
                    videoButton.setImage(UIImage(named:"pinkPlay"), for: .normal)
                } else {
                    videoButton.setImage(UIImage(), for: .normal)
                }
            }
            
            if let videoThumbnail = user.videoThumbnail?.completePath {
                
                thumbnailImageView.kf.indicatorType = .activity
                thumbnailImageView.kf.setImage(with: URL(string: videoThumbnail),placeholder: UIImage(named: "placeholder"))
            }
            
            if let videoURL = user.userVideo?.completePath {
                videoPlayInView(videopath: videoURL)
            }
        }
    }
    
    func openPremiumPopUp() {
        
        let controller = ScreenManager.getPremiumPopUpViewController()
        controller.delegate = self
        let navController = ScreenManager.getCustomNavigationBarNavigationController(controller)
        
        let jellyAnimator = JellyAnimator(presentation: JellyPresentationManager.getSlideInPopupAnimation(targetSize: self.view.bounds.size))
        jellyAnimator.prepare(viewController: navController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func videoPlayInView(videopath:String?=nil) {

        if videoButton.imageView?.image != UIImage(named:"pinkPlay") {
            
            if let path = videopath {
                
                var videoURL = NSURL()
                
                if  path.contains(API.imageBaseURL) {
                    videoURL = NSURL(string:path)!
                }
                
                let playerItem = AVPlayerItem(url: videoURL as URL)
                avPlayer = AVPlayer(playerItem: playerItem)
                
                let playerLayer = AVPlayerLayer(player: avPlayer)
                playerLayer.backgroundColor = UIColor.clear.cgColor
                playerLayer.frame  = playerView.layer.bounds
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                playerView.layer.addSublayer(playerLayer)
                avPlayer.volume = 1.0
                avPlayer.play()
            }
        }
    }
        
    func playVideo() {
        isPopupOpen = false
        avPlayer.play()
    }
    
    func stopVideo() {
        isPopupOpen = true
        avPlayer.pause()
    }
    
    func addPlayerObserver() {
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { _ in
            
            if self.isPopupOpen == true {
                self.avPlayer.pause()
            } else {
                self.avPlayer.seek(to: kCMTimeZero)
                self.avPlayer.play()
            }
        }
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem)
    }
    
    func createGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientView.layoutIfNeeded()
        gradientView.setNeedsLayout()
        
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func showSuccessAlert(message:String)  {
        
        let alertController = UIAlertController(title: App.name, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.navigationController?.popViewController(animated: true)
            self.avPlayer = AVPlayer()
            self.removeObserver()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK:- Button Action
//MARK:-
extension AnotherProfileViewController {
    
    func menuTapped() {
        
        let alertController = UIAlertController()
        alertController.view.tintColor = App.Colors.pink
        
        var title = String()
        
        if let likeStatus = userDetail?.favourite {
            
            if likeStatus == 1 {
                title = "Unfavorite"
            } else {
                title = "Favorite"
            }
        } else {
            title = "Favorite"
        }
        
        let  messageButton = UIAlertAction(title: title, style: .default, handler: { (action) -> Void in
            
            var parameter = [String:Any]()
            parameter["User[user_id]"] = self.userDetail?.id ?? ""
            
            if let likeStatus = self.userDetail?.favourite {
                
                if likeStatus == 1 {
                    parameter["User[review]"] = "0"
                } else {
                    parameter["User[review]"] = "1"
                }
            } else {
                parameter["User[review]"] = "1"
            }
            
            self.serviceReviewUser(parameter: parameter)
            
        })
        
        let blockButton = UIAlertAction(title: "Block User", style: .default, handler: { (action) -> Void in
            self.serviceBlockUser()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(messageButton)
        alertController.addAction(blockButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedChat(_ sender: UIButton) {
        
        stopVideo()
        let controller = ScreenManager.getChatViewController()
        anotherUserModel = UserModel()
        anotherUserModel?.id = self.userDetail?.id
        anotherUserModel?.username = self.userDetail?.username
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func tappedFilter(_ sender: UIButton) {
    }
    
    @IBAction func tappedSwitch(_ sender: UISwitch) {

    }
    
    @IBAction func tappedVideo(_ sender: UIButton) {
        
        if let loggedUser = UserDefaults.getUser() {
            if loggedUser.subscription == nil {
                openPremiumPopUp()
            } else {
            
            if let path = userDetail?.userVideo?.completePath {
                
                stopVideo()
                let videoURL = URL(string: path)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            }
        }
    }
}


//MARK:- CollectionView DateSource,Delegate & FlowLayoutDelegate
//MARK:-
extension AnotherProfileViewController : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.className, for: indexPath) as! AddImageCollectionViewCell
        
        cell.addImage.isHidden = true
        cell.userImage.image = UIImage(named:"placeholder")
        
        if indexPath.row < profileImages.count {
            
            if let image = profileImages[indexPath.row].image {
                cell.userImage.image = image
            } else if let imageUrl = profileImages[indexPath.row].completePath {
                
                cell.userImage.kf.indicatorType = .activity
                cell.userImage.kf.setImage(with: URL(string: imageUrl),placeholder: UIImage(named: "placeholder"))
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: collectionView.frame.size.width/2 - 5, height: collectionView.frame.size.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if profileImages.count > 0 , profileImages.count > indexPath.row{
            
            stopVideo()
            let controller =  ScreenManager.getGalleryViewController()
            controller.userDetail = userDetail
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            controller.delegate = self
            
            self.navigationController?.present(controller, animated: true, completion: nil)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}

//MARK:- GalleryViewControllerDelegate
//MARK:-
extension AnotherProfileViewController : GalleryViewControllerDelegate {
    func didFinishGalleryViewController(controller: GalleryViewController) {
        dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
        playVideo()
    }

}

//MARK:- PremiumPopUpViewControllerDelegate
//MARK:-
extension AnotherProfileViewController : PremiumPopUpViewControllerDelegate {
    
    func didFinishPremiumPopUpViewController(controller:PremiumPopUpViewController) {
        dismiss(animated: false, completion: nil)
        let controller = ScreenManager.getPackagesViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTappedBackPopUpViewController(controller: PremiumPopUpViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Web Service
//MARK:-
extension AnotherProfileViewController {
    
    func serviceGetAnotherUserDetail(userID:String) {
        
        showProgressHUD()
        
        var param = [String:Any]()
        param["id"] = userID
        
        APIManager.shared.request(url: API.getUserDetail, method: .get,parameters:param, completionCallback: { (_) in
            self.hideProgressHUD()
            
        }, success: { (jsonData) in
            
            if let json = jsonData as? [String:Any] {
                
                if let userModel = Mapper<UserModel>().map(JSONObject: json["user"]) {
                    self.userDetail = userModel
                    self.updateProfileData()
                }
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceBlockUser() {
        showProgressHUD()
        
        var param = [String:Any]()
        param["User[user_id]"] = anotherUserModel?.id
        
        APIManager.shared.request(url: API.blockUser, method: .post, parameters: param, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            self.showSuccessAlert(message:"Successfully user blocked")
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
                
                if let id = anotherUserModel?.id {
                    self.serviceGetAnotherUserDetail(userID: id)
                }
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}

