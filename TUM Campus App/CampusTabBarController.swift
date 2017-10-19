//
//  CampusTabBarController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class CampusTabBarController: UITabBarController {
    
    var manager: TumDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = Constants.tumBlue
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
        manager = TumDataManager(user: User.shared)
//        manager?.getUserData()
    }

}
