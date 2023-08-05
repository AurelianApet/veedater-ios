//
//  FilterModel.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 23/11/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import Foundation
import ObjectMapper

class FilterModel:Mappable {
    var longitude:String?
    var latitude:String?
    var gender:String?
    var interestedGender:String?
    var distance:String?
    var age:String?
    var minAge:String?
    var maxAge:String?
    var religion:String?
    var sport:String?
    var minIncome:String?
    var maxIncome:String?
    var style:String?
    var tattoo:String?
    var alchohal:String?
    var smoke:String?
    var nation:String?
    var martial:String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        interestedGender <- map["gender"]
        minAge <- map["min_age"]
        maxAge <- map["max_age"]
        distance <- map["distance"]
        religion <- map["religion"]
        sport <- map["sports"]
        minIncome <- map["min_income"]
        maxIncome <- map["max_income"]
        style <- map["style"]
        alchohal <- map["alchohol"]
        smoke <- map["smoke"]
        tattoo <- map["tatoo"]
        
        if interestedGender == "" {
            interestedGender = "All"
        }
    }
}
