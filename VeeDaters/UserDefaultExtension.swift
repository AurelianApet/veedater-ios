//
//  UserDefaultExtension.swift
//  Chibha
//
//  Created by Sachin Khosla on 10/10/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation
import ObjectMapper

enum userDefaultKeys:String {
    case userDetail = "user_detail"
    case deviceToken = "token"

}

extension UserDefaults {
    
    static func customSet(value:String, key:String) {
    }
    
    static func get(key:userDefaultKeys)->String {
        return  self.value(forKey: userDefaultKeys(rawValue: key.rawValue)!.rawValue) as! String
    }
    
    static func isUserLoggedIn() -> Bool {
        if let _ = getUser() {
            return true
        }
        return false
    }
    
    static func setUser(_ user: UserModel) {
        if let userJSON = Mapper<UserModel>().toJSONString(user) {
            standard.set(userJSON, forKey: userDefaultKeys.userDetail.rawValue)
        }
    }
    
    static func getUser() -> UserModel? {
        
        if let userJSON = standard.value(forKey: userDefaultKeys.userDetail.rawValue) as? String {
            return Mapper<UserModel>().map(JSONString: userJSON)
        }
        return nil
    }
    
    static func clearAllKeysData() {
        standard.removeObject(forKey: userDefaultKeys.userDetail.rawValue)
    }
    
    static func setDeviceToken(_ token: String) {
        standard.set(token, forKey: userDefaultKeys.deviceToken.rawValue)
    }
    
    static func getDeviceToken() -> String? {
        return standard.value(forKey: userDefaultKeys.deviceToken.rawValue) as? String
    }
    
 
}
