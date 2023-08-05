//
//  NSObjectExtension.swift
//  Chibha
//
//  Created by Sachin Khosla on 12/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation

//MARK:- Get Class Name
//MARK:-

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
