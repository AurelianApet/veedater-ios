//
//  CornerRadiusTextField.swift
//  Chibha
//
//  Created by Sachin Khosla on 12/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BorderTextField: UITextField {
    
    @IBInspectable var padding: Bool = false {
        didSet {
            if padding == true {
                addPadding(padding: 10.0)
            } else {
                addPadding(padding: 0.0)
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable  var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
   fileprivate func addPadding(padding:CGFloat) {
    
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
}
