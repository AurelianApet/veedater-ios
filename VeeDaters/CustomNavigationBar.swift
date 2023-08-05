//
//  CustomNavigationBar.swift
//  Helper
//
//  Created by Sachin Khosla on 12/09/17.
//  Copyright © 2017 DigiMantra. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    fileprivate func commonInit() {
        
        barStyle = .default
        barTintColor = UIColor.clear
        isTranslucent = true
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize.zero
//        layer.shadowRadius = 5.0

        
        if UserDefaults.getUser()?.id != nil {
            
            UIApplication.shared.statusBarStyle = .lightContent
            tintColor = UIColor.white
            
            titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            backIndicatorImage = UIImage(named: "blackBack")?.withRenderingMode(.alwaysTemplate)
            backIndicatorTransitionMaskImage = UIImage(named: "blackBack")

        } else {
            
            UIApplication.shared.statusBarStyle = .default
            tintColor = UIColor.black
             
            titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
            backIndicatorImage = UIImage(named: "whiteBack")?.withRenderingMode(.alwaysTemplate)
            backIndicatorTransitionMaskImage = UIImage(named: "whiteBack")
 
        }
    }
}
