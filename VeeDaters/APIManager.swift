//
//  APIManager.swift
//  Chibha
//
//  Created by Sachin Khosla on 12/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//
import Foundation
import Alamofire
import SystemConfiguration

class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    //MARK:- Request Functions
    //MARK:-
    
    func request(url:API,method:HTTPMethod,parameters:Parameters?=nil,token:Int?=nil,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String) -> Void) {
        
        var headerParam:[String:String]?
        headerParam = [String:String]()
        
        if  let id = UserDefaults.getUser()?.id {
            headerParam = ["veedater-header-token":"\(id)"]
        } else if let id = token {
            headerParam = ["veedater-header-token":"\(id)"]
        }
        
        print(headerParam ?? "")
        print(url.urlString)
        if let param = parameters {
            print(param)
        }
        
        URLCache.shared.removeAllCachedResponses()
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.methodDependent, headers: headerParam).responseJSON { (response) in
            
            completionCallback(response as AnyObject)
            
            if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    successCallback(responseJSON as AnyObject)
                case .failure(let error):
                    failureCallback(error.localizedDescription)
                }
            } else {
                let error =  self.getErrorForResponse(response: response)
                failureCallback(error)
            }
        }
    }
    
    
    func upload(url:URLConvertible,method:HTTPMethod,parameters:Parameters?=nil,videoParameter:[String:Any]?=nil,progressCallback:@escaping (AnyObject) -> Void , complete completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String) -> Void) {
        
        print(url)
        if let param = parameters {
            print(param)
        }
        
        var headerParam:[String:String]?
        if  let id = UserDefaults.getUser()?.id {
            headerParam = [String:String]()
            headerParam = ["veedater-header-token":"\(id)"]
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if let parameters = parameters {
                    for (key, value) in parameters {
                        
                        if value is UIImage {
                            if let imageData = UIImageJPEGRepresentation(value as! UIImage, 0.6) {
                                multipartFormData.append(imageData, withName: key, fileName: "\(UUID()).jpeg", mimeType: "image/jpeg")
                            }
                        }
                        
                        let stringValue = "\(value)"
                        multipartFormData.append((stringValue.data(using: .utf8))!, withName: key)
                    }
                }
                
                if let param = videoParameter {
                    for (key, value) in param {
                        
                        let url = URL(fileURLWithPath: value as! String)
                        multipartFormData.append(url, withName: key, fileName: "video.mp4", mimeType: "video/mp4")
                    }
                }
                
        },
            to: url,
            method: method,
            headers: headerParam,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        completionCallback(response as AnyObject)
                        
                        if self.isResponseValid(response: response) {
                            
                            switch response.result {
                            case .success(let responseJSON):
                                successCallback(responseJSON as AnyObject)
                            case .failure(let error):
                                failureCallback(error.localizedDescription)
                            }
                        } else {
                            let error =  self.getErrorForResponse(response: response)
                            failureCallback(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    failureCallback(encodingError.localizedDescription)
                }
        })
    }
    
    func uploadVideo(url:URLConvertible,method:HTTPMethod,parameters:Parameters?=nil,progressCallback:@escaping (AnyObject) -> Void , complete completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String) -> Void) {
        
        print(url)
        if let param = parameters {
            print(param)
        }
        
        var headerParam:[String:String]?
        if  let id = UserDefaults.getUser()?.id {
            headerParam = [String:String]()
            headerParam = ["veedater-header-token":"\(id)"]
        }
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if let parameters = parameters {
                    for (key, value) in parameters {
                        
                        if let videoData = NSData.init(contentsOfFile: value as! String) {
                   //         let data = (value as? String)?.data(using: <#T##String.Encoding#>)
                            
                          //  multipartFormData.append(videoData, withName: key, fileName: "file.mp4", mimeType: "video/mp4")
                        }
                    }
                }
        },
            to: url,
            method: method,
            headers: headerParam,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        completionCallback(response as AnyObject)
                        
                        if self.isResponseValid(response: response) {
                            
                            switch response.result {
                            case .success(let responseJSON):
                                successCallback(responseJSON as AnyObject)
                            case .failure(let error):
                                failureCallback(error.localizedDescription)
                            }
                        } else {
                            let error =  self.getErrorForResponse(response: response)
                            failureCallback(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    failureCallback(encodingError.localizedDescription)
                }
        })
    }
    
    
    //MARK:- Validation (Check response is valid or not)
    //MARK:-
    
    private func isResponseValid(response: DataResponse<Any>) -> Bool {
        if let statusCode = response.response?.statusCode, statusCode < 200 || statusCode >= 300 {
            return false
        }
        
        if let isSuccess = (response.result.value as AnyObject)["is_success"] as? Bool {
            return isSuccess
        }
        
        return true
    }
    

    private func getErrorForResponse(response: DataResponse<Any>) -> String {
        switch response.result {
        case .success(let responseJSON):
            if let responseDictionary = responseJSON as? [String: Any] {
                if let responseCode = responseDictionary["status"] as? Int {
                    if (responseCode == 404) {
                        return App.Error.notFound
                    }
                } else if let errorMessage = responseDictionary["error"] as? String {
                    return errorMessage
                    
                } else if let errorMessage = responseDictionary["message"] as? String {
                    return errorMessage
                    
                } else {
                    
                    for item in responseDictionary {
                        if let errorMessage = (item.value as AnyObject)["email"] as? String {
                            return errorMessage
                        } else  if let errorMessage = (item.value as AnyObject)["username"] as? String {
                            return errorMessage
                        }
                    }
                }
            }
            
            return App.Error.genericError
            
        case .failure(let errorObj):
            return errorObj.localizedDescription
        }
    }
}
