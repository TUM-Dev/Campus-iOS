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

class WaitForTokenViewController: UIViewController {
    
    @IBOutlet weak var button: TKTransitionSubmitButton!
    
    var user: User?
    var lrzID: String?
    var loginManager: TumOnlineLoginRequestManager?
    var delegate: TokenFetcherControllerDelegate?
    
    @IBAction func refresh(_ sender: AnyObject) {
        checkRequest()
    }
    
    func tokenNotConfirmed() {
        button.returnToOriginalState()
    }
    
    func checkRequest() {
        button.startLoadingAnimation()
        loginManager?.confirmToken()
    }

}

extension WaitForTokenViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = Constants.tumBlue
        loginManager = TumOnlineLoginRequestManager(delegate: self)
        lrzID = delegate?.getLRZ()
        loginManager?.lrzID = lrzID
        loginManager?.fetch()
        checkRequest()
    }
    
}

extension WaitForTokenViewController: AccessTokenReceiver {
    
    func receiveToken(_ token: String) {
        user = User(lrzID: token, token: token)
        if let userUnwrapped = user {
            button.startFinishAnimation(delay: TimeInterval(0)) {
                self.loginManager?.loginSuccesful(userUnwrapped)
                if self.presentingViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let mvc = storyboard.instantiateViewController(withIdentifier: "TabBar") as? CampusTabBarController {
                        mvc.transitioningDelegate = self
                        self.present(mvc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

extension WaitForTokenViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
