//
//  VideoModel.swift
//  VeeDaters
//
//  Created by Sachin Khosla on 15/12/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class VideoModel:Mappable {
    
    var id:String?
    var videoURL:String?
    
    var completePath: String? {
        
        if let path = videoURL  {
            return API.imageBaseURL + path
        }
        
        return nil
    }
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        videoURL <- map["video_url"]
    }
    
}

