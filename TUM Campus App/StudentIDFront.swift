//
//  StudentIDFront.swift
//  Campus
//
//  Created by Tim Gymnich on 11/1/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class StudentIDFront: UIView {

    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var matrikelNrLabel: UILabel!
    @IBOutlet weak var chipNrLabel: UILabel!
    @IBOutlet weak var courseOfStudiesLabel: UILabel!
    @IBOutlet weak var validLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }

}
