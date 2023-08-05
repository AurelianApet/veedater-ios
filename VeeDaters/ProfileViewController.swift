
//
//  ProfileViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 31/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//


import UIKit
import GoogleSignIn
import ObjectMapper
import AVFoundation
import FBSDKLoginKit
import Kingfisher
import AVKit
import Jelly
import ImagePicker

class ProfileViewController: UIViewController {
    
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
    
    @IBOutlet weak var alchohalSwitch: UISwitch!
    @IBOutlet weak var smokeSwitch: UISwitch!
    @IBOutlet weak var tattooSwitch: UISwitch!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTextViewHeight: NSLayoutConstraint!
    
    var filterModel = FilterModel()
    var userDetail:UserModel?
    var profileImages = [ProfileImageModel]()
    var deletedImages = [String]()
    var isProfileEdit = Bool(false)
    var profileImageLimit = Int(4)
    let datePicker = UIDatePicker()
    var videoURL = NSURL()
    var avPlayer = AVPlayer()
    var isPopupOpen = Bool(false)
    
    
    override func viewDidLoad() {
       
        configureBarItems()
        configureCollectionView()
        createGradientLayer()
        updateCollectionViewHeight()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isPopupOpen == false || isMembershipPopupOpen == true {
            
            isMembershipPopupOpen = false
            isPopupOpen = false
            initialLoad()
            clearAllFilesFromDirectory()
            addPlayerObserver()
            serviceGetUserProfile()
           
        } else {
            playVideo()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if tabBarController?.selectedIndex != 3 {
            stopVideo()
            isPopupOpen = false
            avPlayer = AVPlayer()
            removeObserver()
        }
    }
}

//MARK:- Custom Function
//MARK:-
extension ProfileViewController {
    
    func initialLoad() {
        
        navigationBarTitle(headerTitle: "Profile", backTitle: "")
        isComponenetInteractionEnable(status: false)

        aboutMeTextView.delegate = self
        addressTextView.delegate = self
        aboutMeTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4 , bottom: 0, right: 0)
        addressTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4 , bottom: 0, right: 0)
        
        let date = Calendar.current.date(byAdding: .year, value: -12, to: Date())
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.maximumDate = date
        birthDayTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)
    }
    
    func configureBarItems() {
        
        if isProfileEdit == false {
            
            let rightBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedEdit))
            self.navigationItem.rightBarButtonItem = rightBarButton
        } else {
            
            let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedDone))
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
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
    
    func isComponenetInteractionEnable(status:Bool) {

        basicView.isUserInteractionEnabled = status
        advanceView.isUserInteractionEnabled = status
        usernameTextField.isUserInteractionEnabled = status
        
        collectionView.reloadData()
    }
    
    func updateProfileData() {
        
        isProfileEdit = false

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
            
            if let videoThumbnail = user.videoThumbnail?.completePath {
                
                thumbnailImageView.contentMode = .scaleAspectFill
                thumbnailImageView.kf.indicatorType = .activity
                thumbnailImageView.kf.setImage(with: URL(string: videoThumbnail),placeholder: UIImage(named: "placeholder"))
            }
            
            if let videoURL = user.userVideo?.completePath {
                videoPlayInView(videopath: videoURL)
            } else {
                
                avPlayer = AVPlayer()
                
                
                if let sublayers = self.playerView.layer.sublayers,sublayers.count > 1  {
                    self.playerView.layer.sublayers?.removeLast()
                }
                
                
                thumbnailImageView.contentMode = .center
                thumbnailImageView.image = UIImage(named:"addVideo")
            }
            
            if user.subscription == nil {
                profileImageLimit = 1
            } else {
                profileImageLimit = 4
            }
            
            //add data in filter model
            
            filterModel.nation = user.nation ?? ""
            filterModel.martial = user.martial ?? ""
            filterModel.gender = user.gender ?? ""
            filterModel.religion = user.religion ?? ""
            filterModel.sport = user.sport ?? ""
            filterModel.style = user.style ?? ""
            filterModel.minIncome = user.minIncome ?? ""
            filterModel.maxIncome = user.maxIncome ?? ""
            filterModel.alchohal = user.alchohal ?? ""
            filterModel.smoke = user.smoke ?? ""
            filterModel.tattoo = user.tattoo ?? ""
        }
    }
    
    func openPremiumPopUp() {
        
        stopVideo()
        let controller = ScreenManager.getPremiumPopUpViewController()
          controller.delegate = self
        let navController = ScreenManager.getCustomNavigationBarNavigationController(controller)
        
        let jellyAnimator = JellyAnimator(presentation: JellyPresentationManager.getSlideInPopupAnimation(targetSize: self.view.bounds.size))
        jellyAnimator.prepare(viewController: navController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func canOpenImagePicker(index:Int) -> Bool {
        
        if index < profileImages.count {
            
            if let _ =  profileImages[index].imageURL {
                if let id = profileImages[index].id {
                    deletedImages.append(id)
                }
                
                profileImages.remove(at: index)
                collectionView.reloadData()
                
            } else if let _ =  profileImages[index].image {
                
                profileImages.remove(at: index)
                collectionView.reloadData()
            } else {
                return true
            }
        } else {
            
            if profileImages.count == profileImageLimit , profileImageLimit == 1 {
                openPremiumPopUp()
                return false
            }
            return true
        }
        return false
    }
    
    func videoPlayInView(videopath:String?=nil) {
        
        if let path = videopath {
            
            videoURL = NSURL()
            
            if  path.contains(API.imageBaseURL) {
                videoURL = NSURL(string:path)!
            } else {
                videoURL = NSURL(fileURLWithPath: path)
            }
            
            let playerItem = AVPlayerItem(url: videoURL as URL)
            avPlayer = AVPlayer()
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
    
    func playVideo() {
        isPopupOpen = false
        avPlayer.play()
    }
    
    func stopVideo() {
        isPopupOpen = true
        avPlayer.pause()
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getDirectoryVideoPath() -> String? {
        
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentsPath)
            
            if filePaths.contains("video.mp4") {
                return "\(documentsPath)/video.mp4"
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func clearAllFilesFromDirectory() {
        
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentsPath)
            
            if filePaths.contains("video.mp4") {
                try fileManager.removeItem(atPath: "\(documentsPath)/video.mp4")
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
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
    
    func getUserAge(dateString: String) -> Int? {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: dateString)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age
    }
    
    func showLogoutAlert()  {
        
        let alertController = UIAlertController(title: App.name, message: "Do you want to logout?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let logout = UIAlertAction(title: "Ok", style: .default) { (alert) in
            
            
            let storage = HTTPCookieStorage.shared
            for cookie in storage.cookies! {
                storage.deleteCookie(cookie)
            }
            
            self.stopVideo()
            self.isPopupOpen = false
            self.removeObserver()
            
            FBSDKLoginManager().logOut()
            FBSDKAccessToken.setCurrent(nil)
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance().disconnect()
            UserDefaults.clearAllKeysData()
            ScreenManager.setAsMainViewController(ScreenManager.getSignInViewController())
        }
        
        alertController.addAction(cancel)
        alertController.addAction(logout)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func submitData() {
        
        var param = [String:Any]()
        param["User[name]"] = usernameTextField.text ?? ""
        param["UserMeta[status]"] = filterModel.martial ?? ""
        param["UserMeta[gender]"] = filterModel.gender ?? ""
        param["UserMeta[about_me]"] = aboutMeTextView.text ?? ""
        param["User[address]"] = addressTextView.text ?? ""
        param["UserMeta[nation]"] = filterModel.nation ?? ""
        param["UserMeta[religion]"] = filterModel.religion ?? ""
        param["UserMeta[sport]"] = filterModel.sport ?? ""
        param["UserMeta[min_income]"] = filterModel.minIncome ?? ""
        param["UserMeta[max_income]"] = filterModel.maxIncome ?? ""
        param["UserMeta[style]"] = filterModel.style ?? ""
        param["UserMeta[smoke]"] = filterModel.smoke ?? ""
        param["UserMeta[alchohol]"] = filterModel.alchohal ?? ""
        param["UserMeta[tatoo]"] = filterModel.tattoo ?? ""

        if let serverDate = DateTimeFormatter.convertToServerDateString(dateString: birthDayTextField.text!) {
            param["UserMeta[dob]"] = serverDate
        }
        
        for (index,profileImage) in profileImages.enumerated() {
            
            if let image = profileImage.image {
                param["User[user_photo][\(index)]"] = image
            }
        }
        
        for (index,id) in deletedImages.enumerated() {
            param["User[photo_id][\(index)]"] = id
        }
        
        if let videoPath = getDirectoryVideoPath() {
            serviceUploadVideo(param: param, videoPath: videoPath)
        } else {
            serviceUpdateProfile(param: param)
        }
    }
}

//MARK:- Button Action
//MARK:-
extension ProfileViewController {
    
    func tappedEdit() {
        isProfileEdit = true

        isComponenetInteractionEnable(status: true)
        configureBarItems()
    }
    
    func tappedDone() {
        
        let videoString = "\(videoURL)"
        
        if videoString.count == 0 {
            showAlert(message: "Please add profile video")
        } else if profileImages.count == 0 {
            showAlert(message: "Please add atleast 1 photos")
        } else if (usernameTextField.text?.isEmpty)! {
            showAlert(message: "Please enter username!")
        }  else if addressTextView.text.isEmpty {
            showAlert(message: "Please enter address!")
        } else if (birthDayTextField.text?.isEmpty)! {
            showAlert(message: "Please select birth date!")
        } else if (genderLabel.text?.isEmpty)! {
            showAlert(message: "Please select gender!")
        } else {
            submitData()
        }
    }
    
    func datePicker(_ sender:UIDatePicker) {
        
        if let appDateString = DateTimeFormatter.convertToAppDateString(date: sender.date) {
            birthDayTextField.text = appDateString
            
            if let age = getUserAge(dateString: birthDayTextField.text!) {
                ageButton.setTitle("\(age)", for: .normal)
            } else {
                ageButton.setTitle("", for: .normal)
            }
        }
    }
    
    @IBAction func tappedFilter(_ sender: UIButton) {
        
        let controller = ScreenManager.getPreferenceCategoryViewController()
        controller.delegate = self
        
        if sender.tag == 1 { //DOB
            birthDayTextField.becomeFirstResponder()
            
        } else if sender.tag == 2 { //Status
            controller.filterType = App.Filter.martial
            
        } else if sender.tag == 3 { //Gender
            controller.filterType = App.Filter.gender
            
        } else if sender.tag == 4 { //Nation
            controller.filterType = App.Filter.nation
            
        } else if sender.tag == 5 { //Religion
            controller.filterType = App.Filter.religion
            
        } else if sender.tag == 6 { //Sport
            controller.filterType = App.Filter.sport
            
        } else if sender.tag == 7 { //Income
            controller.filterType = App.Filter.income
            
        } else if sender.tag == 8 { //Style
            controller.filterType = App.Filter.style
            
        }
        
        if sender.tag != 1 {
            
            stopVideo()
            controller.filterModel = self.filterModel
            let navController = ScreenManager.getCustomNavigationBarNavigationController(controller)
            present(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedSwitch(_ sender: UISwitch) {
        
        if sender.tag == 1 { // Alchohal
            filterModel.alchohal = sender.isOn == true ? "yes" : "no"
        } else if sender.tag == 2 { // smoke
            filterModel.smoke = sender.isOn == true ? "yes" : "no"
        } else if sender.tag == 3 { // Tattoo
            filterModel.tattoo = sender.isOn == true ? "yes" : "no"
        }
    }
    
    @IBAction func tappedLogout(_ sender: UIButton) {
        showLogoutAlert()
    }
    
    @IBAction func tappedVideo(_ sender: UIButton) {
        
        if isProfileEdit == true {
            stopVideo()
            let controller = VideoRecordingController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
            
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
    
    func openImagePicker(_ sender: UIButton) {
        
        if canOpenImagePicker(index: sender.tag) {
            
            stopVideo()
            let imagePickerController = ImagePickerController()
            imagePickerController.imageLimit = 1
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

//MARK:- UITextViewDelegate
//MARK:-
extension ProfileViewController :UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if textView.contentSize.height > 30 {
            
            UIView.animate(withDuration: 0.5) {
                
                if textView == self.aboutMeTextView {
                    self.aboutTextViewHeight.constant = textView.contentSize.height

                } else if textView == self.addressTextView {
                    self.addressTextViewHeight.constant = textView.contentSize.height
                }
            }
        }
        return true
    }
}

//MARK:- CollectionView DateSource,Delegate & FlowLayoutDelegate
//MARK:-
extension ProfileViewController : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.className, for: indexPath) as! AddImageCollectionViewCell
        
        if isProfileEdit == true  {
            
            cell.addImage.isHidden = false
            cell.addImage.tag = indexPath.item
            cell.addImage.addTarget(self, action: #selector(openImagePicker(_:)), for: .touchUpInside)
            cell.userImage.image = UIImage(named:"placeholder")
            
            if indexPath.row < profileImages.count ,profileImages.count > 0  {
                
                cell.addImage.setImage(UIImage(named: "pink_cross"), for: .normal)

                if let image = profileImages[indexPath.row].image {
                    cell.userImage.image = image
                    
                } else if let imageUrl = profileImages[indexPath.row].completePath {
                    
                    cell.userImage.kf.indicatorType = .activity
                    cell.userImage.kf.setImage(with: URL(string: imageUrl),placeholder: UIImage(named: "placeholder"))
                }
            } else {
                cell.addImage.setImage(UIImage(named: "add-button"), for: .normal)
            }
            
        } else {
            
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
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: collectionView.frame.size.width/2 - 5, height: collectionView.frame.size.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isProfileEdit != true {
            
            if profileImages.count > 0 , profileImages.count > indexPath.row {
                stopVideo()
                let controller =  ScreenManager.getGalleryViewController()
                controller.userDetail = userDetail
                controller.selectedIndex = indexPath.row
                controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                controller.delegate = self
                
                self.navigationController?.present(controller, animated: true, completion: nil)
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
}

//MARK:- PreferenceCategoryViewControllerDelegate
//MARK:-
extension ProfileViewController:PreferenceCategoryViewControllerDelegate {
    
    func didFinishWithPreferneceCategoryViewController(filterModel: FilterModel, viewController: UIViewController) {
        self.filterModel = filterModel
        
        nationLabel.text = self.filterModel.nation ?? ""
        statusLabel.text = self.filterModel.martial ?? ""
        genderLabel.text = self.filterModel.gender ?? ""
        religionLabel.text = self.filterModel.religion ?? ""
        sportLabel.text = self.filterModel.sport ?? ""
        styleLabel.text = self.filterModel.style ?? ""
        
        let minIncome = filterModel.minIncome ?? ""
        let maxIncome = filterModel.maxIncome ?? ""
        
        if maxIncome.count > 0 {
            incomeLabel.text = "$\(minIncome) - $\(maxIncome)"
        } else if minIncome.count > 0 {
            incomeLabel.text = "Above $\(minIncome)"
        }
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- GalleryViewControllerDelegate
//MARK:-
extension ProfileViewController : GalleryViewControllerDelegate {
    func didFinishGalleryViewController(controller: GalleryViewController) {
        dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
        playVideo()
    }
}

//MARK:- ImagePickerDelegate
//MARK:-
extension ProfileViewController:ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        dismiss(animated: true, completion: nil)
        if self.profileImages.count < self.profileImageLimit {
            let profileImageModel = ProfileImageModel()
            profileImageModel.image = images[0]
            self.profileImages.append(profileImageModel)
            self.collectionView.reloadData()
        }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        dismiss(animated: true, completion: nil)
        if self.profileImages.count < self.profileImageLimit {
            let profileImageModel = ProfileImageModel()
            profileImageModel.image = images[0]
            self.profileImages.append(profileImageModel)
            self.collectionView.reloadData()
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- VideoRecordingControllerDelegate
//MARK:-
extension ProfileViewController : VideoRecordingControllerDelegate {
    
    func didFinishVideoRecording(_ controller: UIViewController!) {
        controller.dismiss(animated: true) {
            if let videoPath = self.getDirectoryVideoPath() {
                self.videoPlayInView(videopath: videoPath)
            }
        }
    }
}

//MARK:- PremiumPopUpViewControllerDelegate
//MARK:-
extension ProfileViewController : PremiumPopUpViewControllerDelegate {
    
    func didTappedBackPopUpViewController(controller: PremiumPopUpViewController) {
        dismiss(animated: true, completion: nil)
        playVideo()
    }
    
    func didFinishPremiumPopUpViewController(controller:PremiumPopUpViewController) {
        dismiss(animated: false, completion: nil)
        let controller = ScreenManager.getPackagesViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK:- Web Service
//MARK:-
extension ProfileViewController {
    
    func serviceGetUserProfile() {
        
        showProgressHUD()
        
        APIManager.shared.request(url: API.getUserProfile, method: .get, completionCallback: { (_) in
            self.hideProgressHUD()
        }, success: { (jsonData) in
            if let json = jsonData as? [String:Any] {
                
                if let userModel = Mapper<UserModel>().map(JSONObject: json["user"]) {
                    
                    userModel.loginType = UserDefaults.getUser()?.loginType
                    UserDefaults.setUser(userModel)
                    self.userDetail = UserDefaults.getUser()
                    self.isComponenetInteractionEnable(status: false)
                    self.updateProfileData()
                    self.configureBarItems()

                } else {
                    self.showAlert(message: App.Error.genericError)
                }
            } else {
                self.showAlert(message: App.Error.genericError)
            }
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceUpdateProfile(param:[String:Any]) {
        
        showProgressHUD()
        
        APIManager.shared.upload(url: API.updateUserProfile, method: .post, parameters:param,  progressCallback: { (_ ) in
            
        }, complete: { (_ ) in
            self.hideProgressHUD()
            
        }, success: { (jsonData) in
            self.serviceGetUserProfile()
            self.clearAllFilesFromDirectory()
            
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceUploadVideo(param:[String:Any],videoPath:String) {
        
        showProgressHUD()
        
        let videoThumbnail = getThumbnailFrom(path: NSURL(fileURLWithPath:videoPath) as URL)
        
        APIManager.shared.upload(url: API.uploadVideo, method: .post, parameters:["Videos[video_thumb]":videoThumbnail!],videoParameter: ["Videos[video_data]":videoPath],  progressCallback: { (_ ) in
            
        }, complete: { (_ ) in
            self.hideProgressHUD()
            
        }, success: { (jsonData) in
            self.serviceUpdateProfile(param: param)
            
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}

