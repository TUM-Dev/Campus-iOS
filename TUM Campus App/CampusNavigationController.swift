//
//  CampusNavigationController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class CampusNavigationController: UINavigationController {
    
    var loginController: LoginController = LoginController()
    
    override func viewDidLoad() {
        // Decide what to do based on this result
        loginController.confirmToken { result in
            print(result)
        }
    }
    
}
