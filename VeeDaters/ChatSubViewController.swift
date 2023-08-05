//
//  ChatSubViewController.swift
//  Chibha
//
//  Created by Sachin Khosla on 22/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ObjectMapper
import Toucan
import ImagePicker

class ChatSubViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var meassageList : [MessageModel]?
    var popUpView: UIView!
    var blockBtn: UIButton!
    var clearBtn: UIButton!
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: App.Colors.pink)
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: App.Colors.lightGray)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        configureInputToolbar()
        configureCollectionView()
        serviceGetMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver()
    }
}
//MARK:- Custom Functions
//MARK:-
extension ChatSubViewController {
    
    func initialLoad() {
        
        senderId = UserDefaults.getUser()!.id
        senderDisplayName = UserDefaults.getUser()!.username
        
        self.view.backgroundColor = UIColor.clear
    }
    
    func configureCollectionView() {
        
        collectionView.backgroundColor = UIColor.clear
        collectionView?.collectionViewLayout.springinessEnabled = false
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        
        self.collectionView?.layoutIfNeeded()
    }
    
    func configureInputToolbar() {
        
        inputToolbar.clipsToBounds = true
        inputToolbar.layer.borderWidth = 0.3
        inputToolbar.layer.backgroundColor = App.Colors.lightGray.cgColor
        
        inputToolbar.contentView.backgroundColor = App.Colors.whiteBlue
        inputToolbar.layer.borderColor = App.Colors.lightGray.cgColor
        
        inputToolbar.contentView.leftBarButtonItem.setImage(UIImage(named:"chatCamera"), for: .normal)
        inputToolbar.contentView.leftBarButtonItem.backgroundColor = UIColor.clear
        inputToolbar.contentView.leftBarButtonItem.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        
        inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named:"sendMessage"), for: .normal)
        inputToolbar.contentView.rightBarButtonItem.backgroundColor = UIColor.clear
        inputToolbar.contentView.rightBarButtonItem.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
        
        
        inputToolbar.contentView.textView.layer.borderColor =  App.Colors.lightGray.cgColor
        inputToolbar.contentView.textView.backgroundColor = UIColor.white
    }
    
    func chatUpdate() {
        
        for item in meassageList! {
            
            var username = String()
            
            if item.createdID == item.senderID {
                username = item.senderName!
            } else {
                username = item.receiverName!
            }
            
            if let messagePhoto = item.messagePhoto {
                
                let mediaItem = AsyncPhotoMediaItem(withURL: URL(string:  messagePhoto.completePath ?? "")! as NSURL)
                
                if  let message = JSQMessage(senderId: item.createdID, senderDisplayName: username, date: item.chatFullDate(), media: mediaItem){
                    self.messages.append(message)
                }
                
                
            } else {
                if let message = JSQMessage(senderId: item.createdID, senderDisplayName: username, date: item.chatFullDate(), text: item.message) {
                    self.messages.append(message)
                }
            }
        }
        
        self.finishReceivingMessage()
    }
    
    func notificationMessageUpdate(messageModel:MessageModel) {
        
        if let messagePhotoNotification = messageModel.messagePhotoNotification , messagePhotoNotification.count != 0 {
            
            let mediaItem = AsyncPhotoMediaItem(withURL: URL(string:  messageModel.completePath ?? "")! as NSURL)
            
            if  let message = JSQMessage(senderId: messageModel.senderID, senderDisplayName: messageModel.senderName, date: messageModel.chatFullDate(), media: mediaItem){
                self.messages.append(message)
            }
            
            
        } else {
            if let message = JSQMessage(senderId: messageModel.senderID, senderDisplayName: messageModel.senderName, date: messageModel.chatFullDate(), text: messageModel.message) {
                self.messages.append(message)
            }
        }
        
        self.finishReceivingMessage()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name(App.NotificationName.chat), object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(App.NotificationName.chat), object: nil)
    }
    
    func methodOfReceivedNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo as? Dictionary<String, Any> {
            
            if let meassageModel = Mapper<MessageModel>().map(JSONObject: userInfo) {
                notificationMessageUpdate(messageModel: meassageModel)
                
            }
        }
    }
}
//MARK:- Override CollectionView
//MARK:-
extension ChatSubViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.row]
        
        cell.avatarImageView.layoutIfNeeded()
        cell.avatarImageView.setNeedsLayout()
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        cell.avatarImageView.clipsToBounds = true
        
        if !message.isMediaMessage {
            
            if message.senderId == senderId {
                cell.textView.textColor = UIColor.white
                cell.avatarImageView.kf.indicatorType = .activity
                cell.avatarImageView.kf.setImage(with: URL(string: UserDefaults.getUser()?.profileImages?[0].completePath ?? ""),placeholder: App.Placeholders.profile)
                
            } else {
                cell.textView.textColor = UIColor.black
                cell.avatarImageView.kf.indicatorType = .activity
                cell.avatarImageView.kf.setImage(with: URL(string: anotherUserModel?.chatUserImage?.completePath ?? ""),placeholder: App.Placeholders.profile)
            }
        } else {
            
            if message.senderId == senderId {
                cell.avatarImageView.kf.indicatorType = .activity
                cell.avatarImageView.kf.setImage(with: URL(string: UserDefaults.getUser()?.profileImages?[0].completePath ?? ""),placeholder: App.Placeholders.profile)
                
            } else {
                cell.avatarImageView.kf.indicatorType = .activity
                cell.avatarImageView.kf.setImage(with: URL(string: anotherUserModel?.chatUserImage?.completePath ?? ""),placeholder: App.Placeholders.profile)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: messages[indexPath.item].date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "MMM dd,yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        return NSAttributedString(string: myStringafd)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 10
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(message!)
        finishSendingMessage()
        serviceSendMessage(message: text)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
}

//MARK:- ImagePickerDelegate
//MARK:-
extension ChatSubViewController:ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        dismiss(animated: true) {
            let image = images[0]
            let resizedImage = Toucan(image: image).resize(CGSize(width: 200, height: 200), fitMode: Toucan.Resize.FitMode.crop).image
            
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem?.appliesMediaViewMaskAsOutgoing = true
            mediaItem?.image = resizedImage
            if  let sendMessage = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date(), media: mediaItem){
                self.messages.append(sendMessage)
                self.finishSendingMessage()
                self.serviceSendMessage( image: image)
                
            }
        }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        dismiss(animated: true) {
            let image = images[0]
            let resizedImage = Toucan(image: image).resize(CGSize(width: 200, height: 200), fitMode: Toucan.Resize.FitMode.crop).image
            
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem?.appliesMediaViewMaskAsOutgoing = true
            mediaItem?.image = resizedImage
            if  let sendMessage = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date(), media: mediaItem){
                self.messages.append(sendMessage)
                self.finishSendingMessage()
                self.serviceSendMessage( image: image)
                
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Web Services
//MARK:-
extension ChatSubViewController {
    
    func serviceSendMessage(message:String? = nil,image:UIImage? = nil) {
        
     //   showProgressHUD()
        
        var param: [String: Any] = [:]
        
        param["Message[message_body]"] = message ?? ""
        param["Message[message_parent_id]"] = "0"
        
        if let _ = image {
            param["Message[attachment]"] = image
        }
        
        param["Message[recipient_id]"] = anotherUserModel?.id ?? ""
        param["debug_environ"] = debugType ?? ""
        APIManager.shared.upload(url: API.createMessage, method: .post, parameters: param, progressCallback: { (_ ) in
        }, complete: { (_ ) in
            self.hideProgressHUD()
        }, success: { (_ ) in
        }) { (error) in
            self.showAlert(message: error)
        }
    }
    
    func serviceGetMessage() {
        
        showProgressHUD()
        
        var param: [String: Any] = [:]
        param["Message[user_id]"] = anotherUserModel?.id ?? ""
        
        APIManager.shared.request(url:API.messageDetail , method: .post, parameters: param, completionCallback: { (_ ) in
            self.hideProgressHUD()
            
        }, success: { (jsonData) in
            if let json = jsonData as? [String:Any] {
                if let meassageList = Mapper<MessageModel>().mapArray(JSONObject: json["list"]) {
                    self.meassageList = meassageList
                    self.chatUpdate()
                }
            }
        }) { (error) in
            
            self.showAlert(message: error)
        }
    }
    
    func serviceClearChat() {
        
        showProgressHUD()
        
        var param: [String: Any] = [:]
        param["Message[user_id]"] = anotherUserModel?.id ?? ""
        
        APIManager.shared.request(url:API.clearChat , method: .post, parameters: param, completionCallback: { (_ ) in
            self.hideProgressHUD()
            
        }, success: { (jsonData) in
            
            self.meassageList?.removeAll()
            self.messages.removeAll()
            self.chatUpdate()
        }) { (error) in
            self.showAlert(message: error)
        }
    }
}
