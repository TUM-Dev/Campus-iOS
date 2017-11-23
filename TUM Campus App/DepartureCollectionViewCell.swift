//
//  DepartureCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 23.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class DepartureCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {

    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var numberLabel: BorderedLabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var timer: Timer?
    

    
    func setElement(_ element: DataElement) {
    
        if let departure = element as? Departure {
            
            timer = Timer.scheduledTimer(withTimeInterval:1, repeats: true) { _ in
                self.updateTimeRemaining(departure: departure)
            }
            
            if ["u", "s"].contains(departure.product) {
                numberLabel.text = "\(departure.product.uppercased())\(departure.label)"
            } else {
                numberLabel.text = departure.label
            }
            
            destinationLabel.text = departure.destination
            numberLabel.backgroundColor = UIColor(hexString: departure.lineBackgroundColor)
            
            
            updateTimeRemaining(departure: departure)
        }
    }
    
    func updateTimeRemaining(departure: Departure) {
        let secondsLeft = departure.departureTime.timeIntervalSinceNow
        
        let timeLeft: String
        
        if abs(secondsLeft) < 60 {
            timeLeft = "\(Int(secondsLeft)) sec"
        } else {
            timeLeft = "\(Int(secondsLeft / 60)) min"
        }
        
        timeLabel.text = timeLeft
    }
}


