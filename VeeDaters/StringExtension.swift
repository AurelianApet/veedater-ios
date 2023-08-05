//
//  StringExtension.swift
//  Chibha
//
//  Created by Sachin Khosla on 12/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation

extension String {
    
    var parseJSONString: AnyObject? {

        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

        if let jsonData = data {
            do {
                return  try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            } catch  {
                return nil
            }
        } else {
            return nil
        }
    }
}
