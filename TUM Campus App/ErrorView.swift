//
//  ErrorView.swift
//  Campus
//
//  Created by Tim Gymnich on 21.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton! {
        didSet {
            retryButton.layer.borderWidth = 1
            retryButton.layer.borderColor = retryButton.tintColor.cgColor
            retryButton.layer.cornerRadius = 5
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
