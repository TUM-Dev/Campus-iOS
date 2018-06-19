//
//  LoginViewController.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var numbersTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var logoView: TUMLogoView?
    var manager: TumDataManager?
    
    @IBAction func continueWithoutTumId() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    private func openTokenAuthorizationView(tumId: String) {
        PersistentUser.value = .requestingToken(lrzID: tumId)
        performSegue(withIdentifier: "waitForConfirmation", sender: self)
    }
    
    @IBAction func openInputDialog() {
        let alert = UIAlertController(title: "Login", message: "Enter your TUM ID", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil) // TODO
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        alert.addAction(
            UIAlertAction(title: "Continue", style: .default) { action in
                guard let text = alert.textFields![0].text else {
                    return
                }
                self.handleDialogConfirmation(text)
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    private func handleDialogConfirmation(_ input: String) {
        if (input.count != 7) {
            displayErrorDialog(message: "A valid TUM ID consists of 7 characters.")
            return
        }
        
        // Get the first two characters
        let prefixIndex = input.index(input.startIndex, offsetBy: 2)
        
        // Get the last three characters
        let digitsIndex = input.index(prefixIndex, offsetBy: 2)
        
        // Get the two digits in the middle
        //let suffixIndex = input.index(digitsIndex, offsetBy: 3)
        
        let prefix = String(input[..<prefixIndex])
        let suffix = String(input[digitsIndex...])
        let digits = String(input[prefixIndex..<digitsIndex])
        
        let isPrefixValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: prefix))
        let areDigitsValid = Int(digits) != nil
        let isSuffixValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: suffix))
        
        if isPrefixValid && areDigitsValid && isSuffixValid {
            openTokenAuthorizationView(tumId: input)
        } else {
            displayErrorDialog(message: "You entered an invalid TUM ID.")
        }
    }
    
    private func displayErrorDialog(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { action in
                self.openInputDialog()
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    private func setupLogo() {
        let bundle = Bundle.main
        let nib = bundle
            .loadNibNamed("TUMLogoView", owner: nil, options: nil)?
            .compactMap { $0 as? TUMLogoView }
        guard let view = nib?.first else { return }
        logoView = view
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.navigationItem.titleView = view
    }
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PersistentUser.hasEnteredID {
            performSegue(withIdentifier: "waitForConfirmation", sender: self)
        }
        
        setupLogo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
    }
    
}

extension LoginViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
}
