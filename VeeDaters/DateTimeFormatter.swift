//
//  DateTimeFormatter.swift
//  VeeDaters
//
//  Created by Sachin Khosla on 08/01/18.
//  Copyright © 2018 Rishabh Wadhwa. All rights reserved.
//

import Foundation

class DateTimeFormatter {
    
    static let shared = DateTimeFormatter()
    
    private let serverDateFormat = "yyyy-MM-dd"
    private let appDateFormat = "MMM,dd yyyy"
    
    private let serverDateFormatter:DateFormatter
    private let appDateFormatter:DateFormatter
    
    
    private init() {
        serverDateFormatter = DateFormatter()
        appDateFormatter = DateFormatter()
        
        serverDateFormatter.dateFormat = serverDateFormat
        appDateFormatter.dateFormat = appDateFormat
        
    }
    

    class func convertToServerDateString(dateString:String) -> String? {

        if let appDate = shared.appDateFormatter.date(from: dateString) {
            let serverDateString =  shared.serverDateFormatter.string(from: appDate)
            return serverDateString
        }
        
        return nil
    }

    class func convertToAppDateString(dateString:String) -> String? {
        
        if let appDate = shared.serverDateFormatter.date(from: dateString) {
            let appDateString =  shared.appDateFormatter.string(from: appDate)
            return appDateString
        }
        
        return nil
    }
    
    class func convertToAppDateString(date:Date?) -> String? {
        
        if date != nil {
            let appDateString =  shared.appDateFormatter.string(from: date!)
            return appDateString
        }

        return nil
    }
}
