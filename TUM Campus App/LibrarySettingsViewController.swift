
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
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
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
            
        let opac_url = TumOPACApi.OpacURL.rawValue
        let api = BookRentalAPI(baseURL: opac_url)
        
        api.start()
            .onSuccess { csid in
                api.login(user: self.usernameTextField.text!, password: self.passwordTextField.text!, csid: csid)
                    .onSuccess { result in
                        self.saveInKeychain(username: self.usernameTextField.text!, password: self.passwordTextField.text!)
                        self.displayWarning(title: "Success", message: "Done")
                    }
                    .onError { result in
                        self.displayWarning(title: "Error", message: "Username or password is wrong")
                    }
            }
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
    
    func saveInKeychain(username: String, password: String) {
        
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(true, forKey: "hasSavedPassword")
        keychainWrapper.mySetObject(password, forKey:kSecValueData)
        keychainWrapper.writeToKeychain()
        UserDefaults.standard.synchronize()
    }
    
    func logout() {
        
        keychainWrapper.resetKeychainItem()
        UserDefaults.standard.set(false, forKey: "hasSavedPassword")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
    }
    
}
