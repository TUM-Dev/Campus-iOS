//
//  CampusTabBarController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class CampusTabBarController: UITabBarController {
    
    lazy var coreDataStack = appDelegate.persistentContainer
    let loginController: AuthenticationHandler = AuthenticationHandler(delegate: nil)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        login()
    }
    
    private func login() {
        switch loginController.credentials {
        case .none: self.presentLoginViewController()
        case .noTumID?: break
        case .tumID?, .tumIDAndKey?:
            loginController.confirmToken { [weak self] result in
                switch result {
                case .success:
                    break
                case .failure:
                    self?.presentLoginViewController()
                }
            }
        }
    }
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: .main)
        guard let navCon = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
        guard let loginViewController = navCon.children.first as? LoginViewController else { return }
        loginViewController.loginController = loginController
        self.present(navCon, animated: true)
    }
    
}
