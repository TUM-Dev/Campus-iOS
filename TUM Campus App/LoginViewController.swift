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
    
    var manager: TumDataManager?
    
    @IBAction func skip() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func confirm() {
        PersistentUser.value = .requestingToken(lrzID: getLRZ())
        performSegue(withIdentifier: "waitForConfirmation", sender: self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender === firstTextField {
            handleTextFieldInput(currentTextField: firstTextField,
                                 nextTextField: numbersTextField,
                                 characterLimit: 2)
        } else if sender === numbersTextField {
            handleTextFieldInput(currentTextField: numbersTextField,
                                 previousTextField: firstTextField,
                                 nextTextField: secondTextField,
                                 characterLimit: 2)
        } else if sender === secondTextField {
            handleTextFieldInput(currentTextField: secondTextField,
                                 previousTextField: numbersTextField,
                                 characterLimit: 3)
        }

        confirmButton.isEnabled = textFieldContentsAreValid()
        confirmButton.alpha = textFieldContentsAreValid() ? 1 : 0.5
        confirmButton.backgroundColor = Constants.tumBlue
    }

    private func handleTextFieldInput(currentTextField: UITextField, previousTextField: UITextField? = nil, nextTextField: UITextField? = nil, characterLimit: Int) {
        let text = currentTextField.text ?? ""

        if text.count >= characterLimit {
            currentTextField.text = String(text.prefix(characterLimit))

            let substring = String(text.characters.dropFirst(characterLimit))
            if let nextTextField = nextTextField {
                nextTextField.becomeFirstResponder()
                if !substring.isEmpty {
                    nextTextField.text = substring
                    textFieldEditingChanged(nextTextField)
                }
            } else {
                currentTextField.resignFirstResponder()
            }
        } else if text.isEmpty {
            guard let previousTextField = previousTextField else { return }

            previousTextField.becomeFirstResponder()
        }
    }

    func textFieldContentsAreValid() -> Bool {
        guard let firstText = firstTextField.text, firstText.count == 2,
            let numbersText = numbersTextField.text, numbersText.count == 2,
            let secondText = secondTextField.text, secondText.count == 3 else { return false }

        let isFirstTextValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: firstText))
        let isNumbersTextValid = Int(numbersText) != nil
        let isSecondTextValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: secondText))

        highlightTextfield(textField: firstTextField, isHighlighted: !isFirstTextValid)
        highlightTextfield(textField: numbersTextField, isHighlighted: !isNumbersTextValid)
        highlightTextfield(textField: secondTextField, isHighlighted: !isSecondTextValid)

        return isFirstTextValid && isNumbersTextValid && isSecondTextValid
    }

    private func highlightTextfield(textField: UITextField, isHighlighted: Bool) {
        textField.layer.borderWidth = isHighlighted ? 1 : 0
        textField.layer.borderColor = isHighlighted ? UIColor.red.cgColor : UIColor(hexString: "0xC7C7CD").cgColor
    }
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PersistentUser.hasEnteredID {
            performSegue(withIdentifier: "waitForConfirmation", sender: self)
        }
        
        firstTextField.becomeFirstResponder()

        confirmButton.setTitle("🍻", for: .normal)
        confirmButton.setTitle("🎓", for: .disabled)

        let logo = UIImage(named: "logo-blue")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        if let bounds = imageView.superview?.bounds {
            imageView.frame = CGRect(x: bounds.origin.x + 10,
                                     y: bounds.origin.y + 10,
                                     width: bounds.width - 20,
                                     height: bounds.height-20)
        }
        imageView.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
    }
    
}

extension LoginViewController {

    func getLRZ() -> String {
        if let first = firstTextField.text, let numbers = numbersTextField.text, let second = secondTextField.text {
            return first + numbers + second
        }
        return ""
    }
}


extension LoginViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
}
