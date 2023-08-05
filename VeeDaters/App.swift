//
//  App.swift
//  Chibha
//
//  Created by Sachin Khosla on 12/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation
import UIKit
 import Alamofire
class App {
    
    static let name = "VeeDaters"
    static let deviceType = "iOS"
    static let screenSize = UIScreen.main.bounds
    
    class Placeholders {
        static let profile = UIImage(named:"placeholder")
    }
    
    class NotificationName {
        static let chat = "chat"
    }
    
    class Colors {
        
        static let pink = UIColor(red: 238/255, green: 51/255, blue: 134/255, alpha: 1)
        static let lightGray = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        static let darkGray = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)
        static let darkerGray = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1)
        static let whiteBlue = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1)
    }

    //MARK:- Error
    //MARK:-
    class Error {
        static let notFound = "Resource not found"
        static  let invalidResponse = "Invalid response"
        static let networkError = "Something went wrong. Please check your internet connection."
        static let genericError = "Something went wrong. Please try again later."
    }
    
    //MARK:- Filter
    //MARK:-
    class Filter {
        static let gender = "Gender"
        static let martial = "Martial"
        static let nation = "Nation"
        static let interestedGender = "Interested In"
        static let religion = "Religion"
        static let sport = "Sport"
        static let income = "Income"
        static let style = "Style"
    }
}


//MARK:- API Listing
//MARK:-
enum API:String {
    
    static let baseURL: String = "http://veedater.dmlabs.in/api/web/"  //http://googlex.in/veedater/api/web/
    static let imageBaseURL: String = "http://veedater.dmlabs.in/uploads/"
    
    case signup = "v1/user/signup"
    case login = "v1/user/login"
    case forgotPassword = "v1/user/forgotpassword"
    case updateUserProfile = "v1/user/profile-update"
    case getUserProfile = "v1/user/get-profile"
    case getUserDetail = "v1/user/user-detail"

    case getUserList = "v1/user/list"
    case userReview = "v1/user/review"
    case blockUser = "v1/user/block"
    case blockUserList = "v1/user/blocklist"
    case userUnBlock = "v1/user/unblock"
    case favList = "v1/user/favlist"
    
    case getUsersMessageList = "v1/message/list"
    case messageDetail = "v1/message/detail"
    case createMessage = "v1/message/create"
    case clearChat = "v1/message/clearchat"

    case uploadVideo = "v1/video/upload"
    case getVideo = "/v1/user/video"
    case deleteUser = "v1/message/delete-thread"
    case makePayment = "v1/user/subscription"
    case preferences = "v1/user/preferences"
    
    var urlString: String {
        return String(format: "%@%@", API.baseURL, self.rawValue)
    }
}

extension API: URLConvertible {
    func asURL() throws -> URL {
        if self.rawValue.hasPrefix("http") {
            print(try self.rawValue.asURL())
            return try self.rawValue.asURL()
        }
        
        print(try (API.baseURL + self.rawValue).asURL())
        return try (API.baseURL + self.rawValue).asURL()
    }
}




