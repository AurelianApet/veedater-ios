//
//  CircularButton.swift
//  BTV-Host
//
//  Created by Sachin Khosla on 10/02/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CircularButton: UIButton {
    
    @IBInspectable var gradient: Bool = false

    fileprivate var gradientLayer: CAGradientLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let halfOfButtonHeight = layer.frame.height / 2
//        contentEdgeInsets = UIEdgeInsetsMake(10, halfOfButtonHeight, 10, halfOfButtonHeight)
//
//        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//
//        backgroundColor = UIColor.clear
//
//        // setup gradient
//
//        let gradient = CAGradientLayer()
//        gradient.frame = bounds
//        gradient.colors = [UIColor.lightGray.cgColor,App.Colors.puple.cgColor]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.95)
//        gradient.endPoint = CGPoint(x: 1.0, y: 0.05)
//        gradient.cornerRadius = halfOfButtonHeight
//
//        // replace gradient as needed
//        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
//            layer.replaceSublayer(oldGradient, with: gradient)
//        } else {
//            layer.insertSublayer(gradient, below: nil)
//        }
//
//        // setup shadow
//
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: halfOfButtonHeight).cgPath
//        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        layer.shadowOpacity = 0.85
//        layer.shadowRadius = 4.0
        
        let cornerRadius: CGFloat = min(frame.height, frame.width) / 2.0

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        if gradient == true {
            if gradientLayer == nil {
               // addGradient()
            }
        }
    }
    
    
    fileprivate func addGradient() {
        
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.cyan.cgColor,UIColor.magenta.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.95)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.05)
        gradientLayer.masksToBounds = true
        
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradientLayer)
        } else {
            layer.insertSublayer(gradientLayer, below: nil)
        }
        
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2
        
    }
}

