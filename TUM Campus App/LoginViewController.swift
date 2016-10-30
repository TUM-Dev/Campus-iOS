//
//  LoginViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var numbersTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    func getLRZ() -> String {
        if let first = firstTextField.text, let numbers = numbersTextField.text, let second = secondTextField.text {
            return first + numbers + second
        }
        return ""
    }

}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self
        secondTextField.delegate = self
        numbersTextField.delegate = self
        firstTextField.becomeFirstResponder()
        let logo = UIImage(named: "logo-blue")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        if let bounds = imageView.superview?.bounds {
            imageView.frame = CGRect(x: bounds.origin.x+10, y: bounds.origin.y+10, width: bounds.width-20, height: bounds.height-20)
        }
        imageView.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mvc = segue.destination as? WaitForTokenViewController {
            mvc.delegate = self
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate, TokenFetcherControllerDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replaced = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        switch textField {
        case firstTextField:
            if replaced.characters.count == 2 {
                firstTextField.text = replaced
                numbersTextField.becomeFirstResponder()
                return false
            }
            break
        case numbersTextField:
            if replaced.characters.count == 2 {
                numbersTextField.text = replaced
                secondTextField.becomeFirstResponder()
                return false
            } else if replaced == "" {
                numbersTextField.text = ""
                firstTextField.becomeFirstResponder()
                return false
            }
            break
        case secondTextField:
            if replaced.characters.count == 3 {
                secondTextField.text = replaced
                performSegue(withIdentifier: "waitForConfirmation", sender: self)
                return false
            } else if replaced == "" {
                secondTextField.text = ""
                numbersTextField.becomeFirstResponder()
                return false
            }
            break
        default: break
        }
        return true
    }
    
}
