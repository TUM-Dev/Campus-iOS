//
//  LoginViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, TokenFetcherControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self
        secondTextField.delegate = self
        numbersTextField.delegate = self
        firstTextField.becomeFirstResponder()
        self.view.backgroundColor = Constants.backgroundGray
        let logo = UIImage(named: "logo-blue")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.navigationItem.titleView = imageView
        if let bounds = imageView.superview?.bounds {
            imageView.frame = CGRectMake(bounds.origin.x+10, bounds.origin.y+10, bounds.width-20, bounds.height-20)
        }
        imageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let replaced = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
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
                performSegueWithIdentifier("waitForConfirmation", sender: self)
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
    
    func getLRZ() -> String {
        if let first = firstTextField.text, numbers = numbersTextField.text, second = secondTextField.text {
            return first + numbers + second
        }
        return ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mvc = segue.destinationViewController as? WaitForTokenViewController {
            mvc.delegate = self
        }
    }
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var numbersTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!

}
