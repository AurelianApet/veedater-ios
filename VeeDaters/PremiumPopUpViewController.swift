//
//  PremiumPopUpViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 01/01/18.
//  Copyright © 2018 Rishabh Wadhwa. All rights reserved.
//

protocol PremiumPopUpViewControllerDelegate:NSObjectProtocol {
    func didFinishPremiumPopUpViewController(controller:PremiumPopUpViewController)
    func didTappedBackPopUpViewController(controller:PremiumPopUpViewController)

}

import UIKit

class PremiumPopUpViewController: UIViewController {
    
    var delegate:PremiumPopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     
    @IBAction func tapGetMembership(_ sender: UIButton) {
        delegate?.didFinishPremiumPopUpViewController(controller: self)
       
    }
 
    @IBAction func tapDismiss(_ sender: UIButton) {
        delegate?.didTappedBackPopUpViewController(controller: self)
    }    
}
