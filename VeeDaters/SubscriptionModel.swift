//
//  SubscriptionModel.swift
//  VeeDaters
//
//  Created by Sachin Khosla on 04/01/18.
//  Copyright © 2018 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import ObjectMapper

class SubscriptionModel:Mappable {
    
    var id:String?
    var amount:String?
    var duration:String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        amount <- map["amount"]
        duration <- map["months"]
    }
}


