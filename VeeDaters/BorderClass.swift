//
//  BorderClass.swift
//  PoppyAustin
//
//  Created by Rishabh Wadhwa on 04/09/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
 
 @IBDesignable class BorderClass: UIButton {
    
    enum UIButtonBorderSide {
        case top
        case bottom
        case left
        case right
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.white{
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var TopBorder:Bool = false {
        didSet {
            addBorder(side: .top)
        }
    }
    
    @IBInspectable var bottomBorder:Bool = false {
        didSet {
            addBorder(side: .bottom)
        }
    }
    
    @IBInspectable var leftBorder:Bool = false {
        didSet {
            addBorder(side: .left)
        }
    }
    
    @IBInspectable var rightBorder:Bool = false {
        didSet {
            addBorder(side: .right)
        }
    }
    
    
    fileprivate func addBorder (side:UIButtonBorderSide) {
        let border = CALayer()
        border.borderColor = UIColor.clear.cgColor
        border.backgroundColor = borderColor.cgColor
        
        switch side {
        case .top:
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderWidth)
        case .bottom:
            border.frame = CGRect(x:0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
  }
