//
//  LoginViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var continueButton: ShadowButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var numbersTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    var loginController: AuthenticationHandler?
    var tumID: String? {
        guard let firstText = firstTextField.text, let number = numbersTextField.text, let secondText = secondTextField.text else { return nil }
            return "\(firstText)\(number)\(secondText)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        view.addGestureRecognizer(tapGesture)

        continueButton.isEnabled = false
        continueButton.alpha = 0.6
        continueButton.setTitle("Continue", for: .disabled)
        continueButton.setTitle("Continue 🎓", for: .normal)
    }
    
    
    // MARK: - ButtonActions
    
    @IBAction func didSelectContinue(_ sender: Any) {
        guard let tumID = tumID else { return }
        loginController?.createToken(tumID: tumID) { [weak self] result in
            switch result {
            case .success:
                let storyboard = UIStoryboard(name: "Login", bundle: .main)
                guard let confirmVC = storyboard.instantiateViewController(withIdentifier: "TokenConfirmationViewController") as? TokenConfirmationViewController else { return }
                confirmVC.loginController = self?.loginController
                self?.navigationController?.pushViewController(confirmVC, animated: true)
            case .failure:
                // TODO display error message
                self?.continueButton.wiggle()
            }
        }
    }
    
    @IBAction func didSelectContinueWithoutTumID(_ sender: Any) {
        loginController?.skipLogin()
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Keyboard
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - TextFields

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
        
        continueButton.isEnabled = textFieldContentsAreValid()
        continueButton.alpha = textFieldContentsAreValid() ? 1 : 0.6
    }
    
    private func handleTextFieldInput(currentTextField: UITextField, previousTextField: UITextField? = nil, nextTextField: UITextField? = nil, characterLimit: Int) {
        let text = currentTextField.text ?? ""
        let feedbackGenerator = UISelectionFeedbackGenerator()
        
        if text.count >= characterLimit {
            currentTextField.text = String(text.prefix(characterLimit))
            
            let substring = String(text.dropFirst(characterLimit))
            if let nextTextField = nextTextField {
                nextTextField.becomeFirstResponder()
                feedbackGenerator.selectionChanged()
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
            feedbackGenerator.selectionChanged()
        }
    }
    
    private func textFieldContentsAreValid() -> Bool {
        guard let firstText = firstTextField.text, firstText.count == 2,
            let numbersText = numbersTextField.text, numbersText.count == 2,
            let secondText = secondTextField.text, secondText.count == 3 else { return false }
        
        let isFirstTextValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: firstText))
        let isNumbersTextValid = Int(numbersText) != nil
        let isSecondTextValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: secondText))
        
        highlightTextfield(textField: firstTextField, isHighlighted: !isFirstTextValid)
        highlightTextfield(textField: numbersTextField, isHighlighted: !isNumbersTextValid)
        highlightTextfield(textField: secondTextField, isHighlighted: !isSecondTextValid)
        
        let result = isFirstTextValid && isNumbersTextValid && isSecondTextValid
        
        if result == true {
            let feedbackGenereator = UINotificationFeedbackGenerator()
            feedbackGenereator.notificationOccurred(.success)
        }
        
        return result
    }
    
    private func highlightTextfield(textField: UITextField, isHighlighted: Bool) {
        textField.layer.borderWidth = isHighlighted ? 1 : 0
        textField.layer.borderColor = isHighlighted ? UIColor.red.cgColor : UIColor.red.cgColor
    }
    
}
