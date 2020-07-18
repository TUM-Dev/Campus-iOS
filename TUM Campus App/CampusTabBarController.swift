//
//  CampusTabBarController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

final class CampusTabBarController: UITabBarController {
    private let loginController: AuthenticationHandler = AuthenticationHandler()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        login()
    }

    // MARK: - State Restoration (UIStateRestoring)

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

        coder.encode(selectedIndex, forKey: "selectedIndex")
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)

        if coder.containsValue(forKey: "selectedIndex") {
            let decodedIndex = coder.decodeInt64(forKey: "selectedIndex")
            selectedIndex = Int(decodedIndex)
        }
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
                case .failure(let error as AFError) where (error.underlyingError as? URLError)?.code  == URLError.Code.notConnectedToInternet:
                    // We are offline so we cannot confirm the token right now
                    break
                case .failure:
                    self?.presentLoginViewController()
                }
            }
        }
    }
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        guard let navCon = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
        guard let loginViewController = navCon.children.first as? LoginViewController else { return }
        loginViewController.loginController = loginController
        self.present(navCon, animated: true)
    }
    
}
