//
//  BorderImageView.swift
//  Chibha
//
//  Created by Sachin Khosla on 14/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import UIKit

class BorderImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
            layer.masksToBounds = true
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

}
