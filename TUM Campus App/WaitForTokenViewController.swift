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

class WaitForTokenViewController: UIViewController, DetailView {
    
    @IBOutlet weak var button: TKTransitionSubmitButton!
    
    weak var delegate: DetailViewDelegate?
    
    @IBAction func refresh(_ sender: AnyObject) {
        checkRequest()
    }
    
    func checkRequest() {
        guard let loginManager = delegate?.dataManager()?.loginManager else { return }
        button.startLoadingAnimation()
        loginManager.fetch().onSuccess(in: .main) { done in
            self.button.returnToOriginalState()
            if done {
                self.done()
            }
        }
        .onError(in: .main) { _ in self.button.returnToOriginalState() }
    }

}

extension WaitForTokenViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = Constants.tumBlue
        checkRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard !PersistentUser.isLoggedIn else { return }
        PersistentUser.reset()
    }
    
    func done() {
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
