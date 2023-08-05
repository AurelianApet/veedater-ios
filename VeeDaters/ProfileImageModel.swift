//
//  ProfileImageModel.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 22/11/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//


import Foundation
import UIKit
import ObjectMapper

class ProfileImageModel:Mappable {
    
    var id:String?
    var image:UIImage?
    var imageURL:String?
    
    var completePath: String? {
        
        if let path = imageURL  {
            return API.imageBaseURL + path
        }
        
        return nil
    }
    
    var isNew: Bool {
        return image != nil
    }
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["photos_id"]
        imageURL <- map["photo_path"]
    }
    
}
