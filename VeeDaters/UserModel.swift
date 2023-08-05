//
//  UserModel.swift
//  Chibha
//
//  Created by Sachin Khosla on 10/10/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class UserModel:Mappable {
    
    var id:String?
    var username:String?
    var email:String?
    var address:String?
    var distance:String?
    var loginType:String?
    var about:String?
    var age:String?
    var martial:String?
    var dob:String?
    var gender:String?
    var nation:String?
    var religion:String?
    var sport:String?
    var tattoo:String?
    var minIncome:String?
    var maxIncome:String?
    var style:String?
    var smoke:String?
    var alchohal:String?
    var favourite:Int?
    var profileImages:[ProfileImageModel]?
    var userVideo:VideoModel?
    var profileImage:String?
    var chatUserImage:ProfileImageModel?
    var videoThumbnail:ProfileImageModel?
    var subscription:SubscriptionModel?
    
    var completePath: String? {
        
        if let path = profileImage  {
            return API.imageBaseURL + path
        }
        return nil
    }
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        username <- map["name"]
        email <- map["email"]
        address <- map["address"]
        loginType <- map["social_media_type"]
        about <- map["user_meta.about"]
        age <- map["user_meta.age"]
        martial <- map["user_meta.status"]
        distance <- map["miles"]
        dob <- map["user_meta.dob"]
        gender <- map["user_meta.gender"]
        nation <- map["user_meta.nation"]
        religion <- map["user_meta.religion"]
        sport <- map["user_meta.sport"]
        tattoo <- map["user_meta.tatoo"]
        minIncome <- map["user_meta.min_income"]
        maxIncome <- map["user_meta.max_income"]
        style <- map["user_meta.style"]
        smoke <- map["user_meta.smoke"]
        alchohal <- map["user_meta.alchohol"]
        favourite <- map["user_meta.like"]
        profileImages <-  map["userPhoto"]
        profileImage <- map["photo_path"]
        userVideo <- map["userVideo"]
        videoThumbnail <- map["userVideoThumb"]
        subscription <- map["subscription"]
        
        if username == nil {
            username <- map["username"]
        }
    }
}
