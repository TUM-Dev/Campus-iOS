
//
//  LibrarySettingsViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 23.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class LibrarySettingsViewController: UIViewController, DetailView {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    weak var delegate: DetailViewDelegate?
    
    let keychainWrapper = KeychainWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = Constants.tumBlue
        
        if let savedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameTextField.text = savedUsername
        }
        
        if UserDefaults.standard.bool(forKey: "hasSavedPassword") {
            passwordTextField.text = "******"
            loginButton.isHidden = true
            logoutButton.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //Verify Credentials
       
        if usernameTextField.text != "" || passwordTextField.text != "" {
            
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            
            let promise = delegate?.dataManager()?.bookRentalManager.login(username: username,
                                                                           password: password)
            promise?.onSuccess(in: .main) { _ in
                self.displayWarning(title: "Success", message: "Done")
                self.loginButton.isHidden = true
                self.logoutButton.isHidden = false
            }
            .onError(in: .main) { error in
                print(error)
                self.displayWarning(title: "Error", message: "Username or password is wrong")
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
    
    // TODO: Refactor use of keychain wrapper
    // TODO: Move this to the manager. This is really the managers job.
    
    func logout() {
        
        keychainWrapper.resetKeychainItem()
        UserDefaults.standard.set(false, forKey: "hasSavedPassword")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
    }
    
}
