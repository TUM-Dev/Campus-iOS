//
//  TUFilmCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell

class TUFilmCardCell: MCSwipeTableViewCell {
    
    var movie: Movie? {
        didSet {
            if let unwrappedMovie = movie {
                
                
                titleLabel.text = unwrappedMovie.name
                let cal = NSCalendar.currentCalendar()
                let components = cal.components([NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: unwrappedMovie.airDate)
                dateLabel.text = components.day.description + "." + components.month.description
                posterImageView.image = unwrappedMovie.image
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            backgroundColor = UIColor.clearColor()
            cardView.layer.shadowOpacity = 0.4
            cardView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        }
    }
    
    @IBOutlet weak var posterImageView: UIImageView!

}
