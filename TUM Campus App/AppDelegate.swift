//
//  AppDelegate.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initFirebase()
        setupAppearance()
        conditionallyShowLoginViewController()
        return true
    }
    
    private func initFirebase() {
        FirebaseApp.configure()
    }

    private func setupAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.tumBlue]
        UINavigationBar.appearance().tintColor = Constants.tumBlue
    }
    
    private func conditionallyShowLoginViewController() {
        if !PersistentUser.isLoggedIn && !Usage.value {
            let loginViewController = ViewControllerProvider.loginNavigationViewController
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.portrait
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

}

