//
//  WaitForTokenViewController.swift
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
        button.startFinishAnimation(TimeInterval(0)) {
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
