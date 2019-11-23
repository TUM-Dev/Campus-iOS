//
//  ProfileTableViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    let loginController: AuthenticationHandler = AuthenticationHandler(delegate: nil)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 4:
            loginController.logout()
            presentLoginViewController()
        default:
            break
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
