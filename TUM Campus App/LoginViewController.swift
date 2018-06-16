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
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var numbersTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var logoView: TUMLogoView?
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
    }

    private func handleTextFieldInput(currentTextField: UITextField,
                                      previousTextField: UITextField? = nil,
                                      nextTextField: UITextField? = nil, characterLimit: Int) {
        guard let text = currentTextField.text else {
            return
        }

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
        
        firstTextField.becomeFirstResponder()
        
        confirmButton.setTitle("Continue 🍻", for: .normal)
        confirmButton.setTitle("Continue 🎓", for: .disabled)
        
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

extension LoginViewController {
    
    func getLRZ() -> String {
        guard let first = firstTextField.text,
            let numbers = numbersTextField.text, let second = secondTextField.text else {
                return ""
        }
        return first + numbers + second
    }
}


extension LoginViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
}
