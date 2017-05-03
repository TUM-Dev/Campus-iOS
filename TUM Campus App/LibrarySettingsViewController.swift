
//
//  LibrarySettingsViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 23.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class LibrarySettingsViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    let keychainWrapper = KeychainWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameTextField.text = savedUsername
        }
        
        if UserDefaults.standard.bool(forKey: "hasSavedPassword") {
            passwordTextField.text = "******"
            loginButton.isHidden = true
            logoutButton.isHidden = false
        }
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //Verify Credentials
       
        if usernameTextField.text != "" || passwordTextField.text != "" {
            // TODO: Access BookRentalsManager
        } else {
            displayWarning(title: "Error", message: "Please enter a username or password")
        }
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        logout()
        logoutButton.isHidden = true
        loginButton.isHidden = false
//        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
        
    func displayWarning(title: String, message: String) {
            
        let alertView = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func logout() {
        
        keychainWrapper.resetKeychainItem()
        UserDefaults.standard.set(false, forKey: "hasSavedPassword")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
    }
    
}
