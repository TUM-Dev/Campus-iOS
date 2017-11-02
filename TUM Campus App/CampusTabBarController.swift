//
//  CampusTabBarController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

class CampusNavigationController: UINavigationController {
    
    var manager: TumDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = Constants.tumBlue
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
        
        guard let json = Bundle.main.url(forResource: "config", withExtension: "json")
            .flatMap({ try? Data(contentsOf: $0) })
            .flatMap(JSON.init(data:)) else {
                
                return
        }
        manager = TumDataManager(user: PersistentUser.value.user, json: json)
        
        (ViewControllerProvider.loginNavigationViewController.childViewControllers.first as? LoginViewController)?.manager = manager
    }

}
