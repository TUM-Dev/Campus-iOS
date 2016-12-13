//
//  TUFilmCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell

class TUFilmCardCell: CardTableViewCell {
    
    override func setElement(_ element: DataElement) {
        if let unwrappedMovie = element as? Movie{
            titleLabel.text = unwrappedMovie.text
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month, .day], from: unwrappedMovie.airDate as Date)
            dateLabel.text = (components.day?.description)! + "." + (components.month?.description)!
            posterImageView.image = unwrappedMovie.image ?? UIImage(named: "movie")
            posterImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            backgroundColor = UIColor.clear
            cardView.layer.shadowOpacity = 0.4
            cardView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        }
    }
    
    @IBOutlet weak var posterImageView: UIImageView!

}
