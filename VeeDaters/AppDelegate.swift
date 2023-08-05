//
//  AppDelegate.swift
//  VeeDaters
//
//  Created by Rishabh Wadhwa on 30/10/17.
//  Copyright © 2017 Rishabh Wadhwa. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import Google
import CoreLocation
import Stripe
import UserNotifications
import GLNotificationBar


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        detectDebugMode()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        IQKeyboardManager.sharedManager().enable = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ScreenManager.getRootViewController()
        UIApplication.shared.statusBarStyle = .lightContent
        window?.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "146191762559-errpf3t8la2cp5npjchl1qt2mmk3h9og.apps.googleusercontent.com"
        STPPaymentConfiguration.shared().publishableKey = "pk_test_tZGIOK0ezwLGPerGW5xnKOmP"
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let isHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return isHandled
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let  tokenString = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
        print("deviceToken: \(tokenString)")
        UserDefaults.setDeviceToken(tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleNotification(userInfo: userInfo)
    }
    
    func detectDebugMode() {
        
        #if DEBUG
            debugType = "developer"
        #else
            debugType = "production"
        #endif
    }
    
    func handleNotification(userInfo: [AnyHashable : Any]) {
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                
                if let message = alert["body"] as? NSString {
                    
                    if let title = alert["type"] as? NSString {
                        
                        if title == "chat" {
                            
                            if ScreenManager.getCurrentViewController()?.className == ScreenManager.getChatViewController().className {
                                
                                if let customMessage = alert["custom"] as? String {
                                    
                                    if let userInfo = customMessage.parseJSONString as? Dictionary<String, Any> {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: App.NotificationName.chat), object:nil , userInfo:userInfo)
                                    }
                                }
                            } else {
                                
                                let notificationBar = GLNotificationBar(title: "", message: message as String, preferredStyle: .detailedBanner, handler: nil)
                                notificationBar.showTime(3.0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

