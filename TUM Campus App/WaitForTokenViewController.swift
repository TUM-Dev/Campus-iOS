//
//  WaitForTokenViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

protocol TokenFetcherControllerDelegate {
    func getLRZ() -> String
}

class WaitForTokenViewController: UIViewController, AccessTokenReceiver {
    
    var user: User?
    var lrzID: String?
    
    var loginManager: TumOnlineLoginRequestManager?
    var delegate: TokenFetcherControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        loginManager = TumOnlineLoginRequestManager(delegate: self)
        lrzID = delegate?.getLRZ()
        loginManager?.lrzID = lrzID
        loginManager?.fetch()
        checkRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receiveToken(token: String) {
        user = User(lrzID: token, token: token)
        if let userUnwrapped = user {
            loginManager?.LoginSuccesful(userUnwrapped)
            DoneHUD.showInView(self.view, message: "Login Succesful")
            if presentingViewController != nil {
                performSegueWithIdentifier("loggedIn", sender: self)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as? AppDelegate)!
                self.dismissViewControllerAnimated(true, completion: nil)
                appDelegate.window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("TabBar") as? CampusTabBarController
            }
        }
    }
    @IBAction func refresh(sender: AnyObject) {
        checkRequest()
    }
    
    func checkRequest() {
        loginManager?.confirmToken()
    }

}
