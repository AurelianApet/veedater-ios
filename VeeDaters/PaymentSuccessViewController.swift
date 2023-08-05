//
//  PaymentSuccessViewController.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 02/01/18.
//  Copyright © 2018 Rishabh Wadhwa. All rights reserved.
//

import UIKit

class PaymentSuccessViewController: UIViewController {

    @IBOutlet weak var subTitleLabel: UILabel!
    var price = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
    
}

//MARK:- Custom Function
//MARK:- 
extension PaymentSuccessViewController {
    func initialLoad() {
        
        subTitleLabel.text = "Your payment of $\(price) \n was successfully completed"
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                isMembershipPopupOpen = true
                self.popToSpecificController()
            }
        })
    }
}

//MARK:- Button Action
//MARK:-
extension PaymentSuccessViewController {

    @IBAction func tapDiscover(_ sender: UIButton) {        
        removeAnimate()
    }
}
