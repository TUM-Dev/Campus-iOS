//
//  MessageViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.3.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import Foundation
import UIKit
import FirebaseRemoteConfig
#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif

final class MessageViewController: UIViewController {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var primaryButton: ShadowButton!
    @IBOutlet weak private var secondaryButton: ShadowButton!

    private let config = RemoteConfig.remoteConfig()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        isModalInPresentation = true
    }

    private func setupUI() {
        self.titleLabel.text = config.configValue(forKey: "sunset_message_title").stringValue
        self.messageLabel.text = config.configValue(forKey: "sunset_message_text").stringValue
        self.primaryButton.setTitle("Show in AppStore", for: .normal)
        self.secondaryButton.setTitle("Hide", for: .normal)

        if self.config.configValue(forKey: "sunset_message_can_hide").boolValue {
            self.secondaryButton.isHidden = false
            self.secondaryButton.isEnabled = true
        } else {
            self.secondaryButton.isHidden = true
            self.secondaryButton.isEnabled = false
        }
    }

    @IBAction private func primaryAction() {
        guard let urlString = config.configValue(forKey: "sunset_message_url").stringValue,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
        #if !targetEnvironment(macCatalyst)
        Analytics.logEvent("sunset_message_appstore", parameters: nil)
        #endif
    }

    @IBAction private func secondaryAction() {
        self.dismiss(animated: true, completion: nil)
        #if !targetEnvironment(macCatalyst)
        Analytics.logEvent("sunset_message_hide", parameters: nil)
        #endif
    }

}
