//
//  ProfileModel.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 14/11/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class ProfileModel:Mappable {

    var id:String?
    var video:String?
    var name:String?
    var status:String?
    var gender:String?
    var about:String?
    var address:String?
    var dob:String?
    var age:String?
    var nation:String?
    var religion:String?
    var sport:String?
    var travel:String?
    var income:String?
    var style:String?
    var smoke:String?
    var beer:String? 
    
    
    init() {
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        status <- map["user_meta.status"]
        gender <- map["user_meta.gender"]
        about <- map["user_meta.about"]
        address <- map["address"]
        dob <- map["user_meta.dob"]
        nation <- map["user_meta.nation"]
        religion <- map["user_meta.religion"]
        sport <- map["user_meta.sport"]
        travel <- map["user_meta.travel"]
        income <- map["user_meta.income"]
        style <- map["user_meta.style"]
        smoke <- map["user_meta.smoke"]
        beer <- map["user_meta.beer"]        
    }
    
}
