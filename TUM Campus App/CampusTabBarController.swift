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
        
        let loginViewController = ViewControllerProvider.loginNavigationViewController
        
        (loginViewController.childViewControllers.first as? LoginViewController)?.manager = manager
        
        manager?.config.tumOnline.onError { error in
            guard case .invalidToken = error, PersistentUser.isLoggedIn else { return }
            self.checkToken(loginViewController: loginViewController)
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
