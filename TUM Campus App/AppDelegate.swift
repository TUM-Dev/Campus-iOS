//
//  AppDelegate.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupAppearance()
        conditionallyShowLoginViewController()

        return true
    }

    private func setupAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constants.tumBlue]
        UINavigationBar.appearance().tintColor = Constants.tumBlue
    }
    
    private func conditionallyShowLoginViewController() {
        if !PersistentUser.isLoggedIn && !Usage.value {
            let loginViewController = ViewControllerProvider.loginNavigationViewController
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(loginViewController, animated: true, completion: nil)
        }
    }

}

