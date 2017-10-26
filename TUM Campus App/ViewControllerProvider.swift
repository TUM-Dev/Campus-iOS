//
//  ViewControllerProvider.swift
//  TUM Campus App
//
//  Created by Robert on 06.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

enum ViewControllerProvider {
    static private(set) var loginNavigationViewController: UIViewController = {
        let storyboard = UIStoryboard(name: "Setup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Login")
    }()
}
