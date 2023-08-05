//
//  MessagesModel.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 23/11/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class MessageModel:Mappable {
    
    var id:String?
    var receiverID:String?
    var senderID:String?
    var createdID:String?
    var createdDate:String?
    var message:String?
    var senderName:String?
    var receiverName:String?
    var senderImage:ProfileImageModel?
    var receiverImage:ProfileImageModel?
    var messagePhoto:ProfileImageModel?
    var time:String?
    var readStatus:String?
    var messagePhotoNotification:String?

    var completePath: String? {
        
        if let path = messagePhotoNotification  {
            return API.imageBaseURL + path
        }
        return nil
    }
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["message_id"]
        receiverID <- map["info.reciever.id"]
        senderID <- map["info.sender.id"]
        createdID <- map["createdby"]
        createdDate <- map["createddate"]
        message <- map["message_body"]
        messagePhoto <- map["messagePhoto"]
        senderName <- map["info.sender.username"]
        receiverName <- map["info.reciever.username"]
        senderImage <- map["info.sender.suserPhoto"]
        receiverImage <- map["info.reciever.ruserPhoto"]
        time <- map["createddate"]
        readStatus <- map["info.is_read"]
        messagePhotoNotification <- map["photo_path"]
        
        if senderID == nil,senderName == nil, message != nil , createdDate != nil {
            senderID <- map["sender_id"]
            senderName <- map["sender_username"]
        }
    }
    
    func chatFullDate() -> Date? {
        
        if let date = createdDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let yourDate = formatter.date(from: date)
            return yourDate
        }
        return nil
    }
}

