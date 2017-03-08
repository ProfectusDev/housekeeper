//
//  AppDelegate.swift
//  OpenHouse
//
//  Created by Arjun Chib on 11/7/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct defaultsKeys {
    static let email = "email"
    static let password = "password"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let myHousesVC = MyHousesViewController()
        let rootVC = RootViewController(rootViewController: myHousesVC)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        Style.screenWidth = UIScreen.main.bounds.size.width
        Style.screenHeight = UIScreen.main.bounds.size.height
        
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: defaultsKeys.email)
        let password = defaults.string(forKey: defaultsKeys.password)
        
        if ((email != nil) && (password != nil)) {
            let parameters: Parameters = ["email": email!, "password": password!]
            Alamofire.request(Networking.baseURL + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    if (response.error != nil) {
                        self.launchLoginVC(rootVC: rootVC)
                        return
                    }
                    let success = validate(statusCode: (response.response?.statusCode)!)
                    if success {
                        let json = JSON(response.data!)
                        Networking.token = json["token"].stringValue
                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "loadHouses")))
                    }
            }
        } else {
            launchLoginVC(rootVC: rootVC)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func launchLoginVC(rootVC: UIViewController) {
        let userVC = UINavigationController()
        userVC.setViewControllers([LoginViewController(), RegistrationViewController()], animated: false)
        userVC.setNavigationBarHidden(true, animated: false)
        rootVC.present(userVC, animated: false, completion: nil)
    }


}

