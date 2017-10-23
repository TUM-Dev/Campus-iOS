//
//  SearchResultsNavigationController.swift
//  Campus
//
//  Created by Tim Gymnich on 23.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class SearchResultsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didSelectBackButton(sender:)))
        
        self.navigationItem.backBarButtonItem = backButton
        if let destination = self.topViewController as? UIViewController {
            destination.navigationItem.leftBarButtonItem = backButton
        }
    }

    @IBAction func didSelectBackButton(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
