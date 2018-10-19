//
//  CampusTabBarController.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
        
        let loginViewController = ViewControllerProvider.loginNavigationViewController
        
        (loginViewController.children.first as? LoginViewController)?.manager = manager
        
        manager?.config.tumOnline.onError { [weak self] error in
            guard case .invalidToken = error, PersistentUser.isLoggedIn else { return }
            self?.checkToken(loginViewController: loginViewController)
        }
    }
    
    func checkToken(loginViewController: UIViewController) {
        manager?.loginManager.fetch().onSuccess(in: .main) { [weak self] tokenCorrect in
            guard !tokenCorrect else { return }
            self?.manager?.loginManager.logOut()
            
            (loginViewController as? UINavigationController)?.popToRootViewController(animated: false)
            self?.present(loginViewController, animated: true)
        }
    }

}
