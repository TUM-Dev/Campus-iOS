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
    @IBOutlet weak var confirmButton: UIButton!
    

    
    @IBAction func skip() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func confirm() {
        performSegue(withIdentifier: "waitForConfirmation", sender: self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {

        let text = sender.text ?? ""

        if sender === firstTextField {
            if text.count >= 2 {
                sender.text = String(text.prefix(2))
                numbersTextField.becomeFirstResponder()
            }
        } else if sender === numbersTextField {
            if text.count >= 2 {
                sender.text = String(text.prefix(2))
                secondTextField.becomeFirstResponder()
            } else if text.isEmpty {
                firstTextField.becomeFirstResponder()
            }
        } else if sender === secondTextField {
            if text.count >= 3 {
                sender.text = String(text.prefix(3))
                secondTextField.resignFirstResponder()
            } else if text.isEmpty {
                numbersTextField.becomeFirstResponder()
            }
        }

        confirmButton.isEnabled = textFieldContentsAreValid()
        confirmButton.alpha = textFieldContentsAreValid() ? 1 : 0.5
    }

    func textFieldContentsAreValid() -> Bool {
        guard (firstTextField.text ?? "").count == 2, (secondTextField.text ?? "").count == 3,
            let numbers = numbersTextField.text, numbers.count == 2 else { return false }

        if let _ = Int(numbers) {
            numbersTextField.layer.borderColor = UIColor(hexString: "0xC7C7CD").cgColor
            return true
        } else {
            numbersTextField.layer.borderWidth = 1
            numbersTextField.layer.borderColor = UIColor.red.cgColor
            return false
        }
    }
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstTextField.becomeFirstResponder()

        confirmButton.setTitle("🍻", for: .normal)
        confirmButton.setTitle("🎓", for: .disabled)

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

extension LoginViewController: TokenFetcherControllerDelegate {

    func getLRZ() -> String {
        if let first = firstTextField.text, let numbers = numbersTextField.text, let second = secondTextField.text {
            return first + numbers + second
        }
        return ""
    }
}
