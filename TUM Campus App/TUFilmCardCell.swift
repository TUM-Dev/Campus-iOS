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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var binding: ImageViewBinding?
    
    override func setElement(_ element: DataElement) {
        binding = nil
        if let movie = element as? Movie{
            titleLabel.text = movie.text
            let day = String (Calendar.current.component(.day, from: movie.airDate))
            let month = String(Calendar.current.component(.month, from: movie.airDate))
            dateLabel.text = day + "." + month
            binding = movie.poster.bind(to: posterImageView, default: #imageLiteral(resourceName: "movie"))
            posterImageView.clipsToBounds = true
        }
    }
}
