//
//  TokenActivationTutorialViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 21.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
#if !targetEnvironment(macCatalyst)
import FirebaseAnalytics
#endif

final class TokenActivationTutorialViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage.animatedImageNamed("token_step", duration: 10)
            imageView.isAccessibilityElement = true
            imageView.accessibilityLabel = "animation showing the token activation".localized
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if !targetEnvironment(macCatalyst)
        Analytics.logEvent(AnalyticsEventTutorialBegin, parameters: nil)
        #endif
    }
}
