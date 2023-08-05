//
//  ScreenManager.swift
//  veeDaters
//
//  Created by Rishabh Wadhwa on 30/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import Foundation
import UIKit

class ScreenManager {
    
    private init() {}
    
    class func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func getCustomNavigationBarNavigationController(_ viewController:UIViewController?=nil) -> UINavigationController {
        
        let navigationController = UINavigationController(navigationBarClass: CustomNavigationBar.self, toolbarClass: UIToolbar.self)
        if let controller = viewController {
            navigationController.viewControllers = [controller]
        }
        return navigationController
    }
    
    
    class func setAsMainViewController(_ viewController: UIViewController) {
        
        if viewController.isKind(of: UITabBarController.self) {
            UIApplication.shared.keyWindow?.rootViewController = viewController
        } else {
            let rootController = getCustomNavigationBarNavigationController(viewController)
            UIApplication.shared.keyWindow?.rootViewController = rootController
        }
    }
    
    class func getRootViewController() -> UIViewController? {
        
        if let _  = UserDefaults.getUser()?.id {
            return getTabbarWIthItems()
        } else {
            return getCustomNavigationBarNavigationController(getSignInViewController())
        }
    }

    class func getCurrentViewController() -> UIViewController? {
        
        if let tabbarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            
            if let navController = tabbarController.selectedViewController  as? UINavigationController{
                
                if let controller = navController.viewControllers.last as? UIViewController {
                    return controller
                }
            }
        }
        
        return nil
    }
    
    //MARK:- Tabbar
    //MARK:-
    
    class func getTabbarWIthItems() -> UITabBarController {
      
         let tabBarController = UITabBarController()        

        let item1 = getCustomNavigationBarNavigationController(getNearByViewController())
        let item2 = getCustomNavigationBarNavigationController(getMessageViewController())
        let item3 = getCustomNavigationBarNavigationController(getDiscoverViewController())
        let item4 = getCustomNavigationBarNavigationController(getProfileViewController())
        let item5 = getCustomNavigationBarNavigationController(getSettingViewController())

        
        tabBarController.viewControllers = [item1,item2,item3,item4,item5]
        tabBarController.tabBar.barTintColor = UIColor.white
 
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.tintColor = App.Colors.pink
        tabBarController.tabBar.layer.borderColor = App.Colors.lightGray.cgColor
        
        item1.tabBarItem = UITabBarItem(title: "Nearby", image: UIImage(named: "map")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "map_select")?.withRenderingMode(.alwaysOriginal))
        item2.tabBarItem = UITabBarItem(title: "Message", image: UIImage(named:"message")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "message_select")?.withRenderingMode(.alwaysOriginal))
        item3.tabBarItem = UITabBarItem(title: "VSearch", image: UIImage(named:"discovery")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "discovery_select")?.withRenderingMode(.alwaysOriginal))
        item4.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named:"profile")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "profile_select")?.withRenderingMode(.alwaysOriginal))
        item5.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named:"setting")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "setting_color")?.withRenderingMode(.alwaysOriginal))

        
        return tabBarController
    }
    
    //MARK:- Registration
    //MARK:-
    class func getSignUpViewController() -> SignUpViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: SignUpViewController.className) as! SignUpViewController
    }
    
    class func getSignInViewController() -> SignInViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: SignInViewController.className) as! SignInViewController
    }
    
    class func getForgotPasswordViewController() -> ForgotPasswordViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: ForgotPasswordViewController.className) as! ForgotPasswordViewController
    }
    
    //MARK:- Prefernces & Filter
    //MARK:-
    
    class func getPreferencesViewController() -> PreferencesViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: PreferencesViewController.className) as! PreferencesViewController
    }
    
    class func getPreferenceCategoryViewController() -> PreferenceCategoryViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: PreferenceCategoryViewController.className) as! PreferenceCategoryViewController
    }
    
    
    class func getDiscoverViewController() -> DiscoverViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: DiscoverViewController.className) as! DiscoverViewController
    }
    
    class func getFilterViewController() -> FilterViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: FilterViewController.className) as! FilterViewController
    }

    class func getMessageViewController() -> MessageViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: MessageViewController.className) as! MessageViewController
    }
    
    class func getChatViewController() -> ChatViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
    }
    
    class func getChatSubViewController() -> ChatSubViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: ChatSubViewController.className) as! ChatSubViewController
    }
    
    class func getNearByViewController() -> NearByViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: NearByViewController.className) as! NearByViewController
    }
    
    class func getProfileViewController() -> ProfileViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: ProfileViewController.className) as! ProfileViewController
    }
    
    class func getAnotherProfileViewController() -> AnotherProfileViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: AnotherProfileViewController.className) as! AnotherProfileViewController
    }
    
    
    class func getFavoriteViewController() -> FavoriteViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: FavoriteViewController.className) as! FavoriteViewController
    }
    

    
    class func getSettingViewController() -> SettingViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: SettingViewController.className) as! SettingViewController
    }
    
    
    class func getBlockListViewController() -> BlockListViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: BlockListViewController.className) as! BlockListViewController
    }
    
    class func getGalleryViewController() -> GalleryViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: GalleryViewController.className) as! GalleryViewController
    }
    
    class func getPackagesViewController() -> PackagesViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: PackagesViewController.className) as! PackagesViewController
    }
    
    class func getPremiumPopUpViewController() -> PremiumPopUpViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: PremiumPopUpViewController.className) as! PremiumPopUpViewController
    }
    
    class func getCreditCardViewController() -> CreditCardViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: CreditCardViewController.className) as! CreditCardViewController
    }
    
    class func getPaymentSuccessViewController() -> PaymentSuccessViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: PaymentSuccessViewController.className) as! PaymentSuccessViewController
    }
    
    class func getChangePasswordViewController() -> ChangePasswordViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: ChangePasswordViewController.className) as! ChangePasswordViewController
    }
    
}
