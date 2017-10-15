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
    
    @IBAction func skip(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
        let numberOfCharacterPerTextField = [2, 2, 3]
        let textFields = [firstTextField, numbersTextField, secondTextField]
        
        guard let textFieldIndex = textFields.index(where: { $0 == textField })
            else { return true }
        
        if replaced == "" {
            textField.text = ""
            textFields[max(0, textFieldIndex - 1)]?.becomeFirstResponder()
            return false
        } else if string.characters.count < range.length {
            return true
        }
    
        var mutableReplaced = replaced
        
        for i in textFieldIndex..<textFields.endIndex {
            let startIndex = mutableReplaced.startIndex
            let endIndex = replaced.index(startIndex, offsetBy: min(mutableReplaced.characters.count, numberOfCharacterPerTextField[i]) - 1)
            let range = ClosedRange(uncheckedBounds: (lower: startIndex, upper: endIndex))
            textFields[i]?.text = mutableReplaced[range]
            textFields[i]?.becomeFirstResponder()
        
            mutableReplaced.removeSubrange(range)
            
            if mutableReplaced.characters.count == 0 {
                
                if textFields[i]?.text?.characters.count == numberOfCharacterPerTextField[i] {
                    textFields[min(textFields.count - 1, i + 1)]?.becomeFirstResponder()
                }
                
                break
            }
        }
        
        if textFieldContentsAreValid() {
            self.view.endEditing(true)
            performSegue(withIdentifier: "waitForConfirmation", sender: self)
        }
        
        return false
    }
    
    private func textFieldContentsAreValid() -> Bool {
        guard let firstText = firstTextField.text, let numbers = numbersTextField.text, let secondText = secondTextField.text, let _ = Int(numbers)
            else { return false }
        return firstText.characters.count == 2 && numbers.characters.count == 2 && secondText.characters.count == 3
    }
    
}
