//
//  TuitionCard.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class TuitionCardTableViewCell: CardTableViewCell {

    override func setElement(element: DataElement) {
        if let tuitionElement = element as? Tuition {
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "MMM dd, yyyy"
            deadLineLabel.text = dateformatter.stringFromDate(tuitionElement.frist)
            balanceLabel.text = tuitionElement.soll + " €"
        }
    }
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            backgroundColor = UIColor.clearColor()
            cardView.layer.shadowOpacity = 0.4
            cardView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        }
    }

    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
}
