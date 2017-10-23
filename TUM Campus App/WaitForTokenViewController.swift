//
//  WaitForTokenViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft
import TKSubmitTransition

class WaitForTokenViewController: UIViewController {
    
    @IBOutlet weak var button: TKTransitionSubmitButton!
    
    lazy var loginManager: TumOnlineLoginRequestManager = { TumOnlineLoginRequestManager(delegate: self) }()
    
    @IBAction func refresh(_ sender: AnyObject) {
        checkRequest()
    }
    
    func tokenNotConfirmed() {
        button.returnToOriginalState()
    }
    
    func checkRequest() {
        button.startLoadingAnimation()
        loginManager.confirmToken()
    }

}

extension WaitForTokenViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = Constants.tumBlue
        if PersistentUser.hasRequestedToken {
            checkRequest()
        } else {
            button.startLoadingAnimation()
            loginManager.fetch()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard !PersistentUser.isLoggedIn else { return }
        PersistentUser.reset()
    }
    
}

extension WaitForTokenViewController: AccessTokenReceiver {
    
    func receiveToken(_ token: String) {
        button.startFinishAnimation(delay: TimeInterval(0)) {
            if self.presentingViewController != nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let mvc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? CampusNavigationController {
                    mvc.transitioningDelegate = self
                    self.present(mvc, animated: true, completion: nil)
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
