//
//  WaitForTokenViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import TKSubmitTransition

protocol TokenFetcherControllerDelegate {
    func getLRZ() -> String
}

class WaitForTokenViewController: UIViewController, AccessTokenReceiver, UIViewControllerTransitioningDelegate {
    
    var user: User?
    var lrzID: String?
    
    var loginManager: TumOnlineLoginRequestManager?
    var delegate: TokenFetcherControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        button.normalBackgroundColor = Constants.tumBlue
        button.highlightedBackgroundColor = Constants.tumBlue
        loginManager = TumOnlineLoginRequestManager(delegate: self)
        lrzID = delegate?.getLRZ()
        loginManager?.lrzID = lrzID
        loginManager?.fetch()
        checkRequest()
    }
    
    @IBOutlet weak var button: TKTransitionSubmitButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receiveToken(token: String) {
        user = User(lrzID: token, token: token)
        if let userUnwrapped = user {
            button.startFinishAnimation(NSTimeInterval(0)) {
                self.loginManager?.LoginSuccesful(userUnwrapped)
                if self.presentingViewController != nil {
                    self.performSegueWithIdentifier("loggedIn", sender: self)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let mvc = storyboard.instantiateViewControllerWithIdentifier("TabBar") as? CampusTabBarController {
                        mvc.transitioningDelegate = self
                        self.presentViewController(mvc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func tokenNotConfirmed() {
        button.returnToOriginalState()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        checkRequest()
    }
    
    func checkRequest() {
        button.startLoadingAnimation()
        loginManager?.confirmToken()
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
