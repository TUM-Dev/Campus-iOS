//
//  TUFilmCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 17.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class TUFilmCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var binding: ImageViewBinding?
    
    func setElement(_ element: DataElement) {
        binding = nil
        guard let movie = element  as? Movie else { return }
        movieTitleLabel.text = movie.text
//        let day = String (Calendar.current.component(.day, from: movie.airDate))
//        let month = String(Calendar.current.component(.month, from: movie.airDate))
//        dateLabel.text = day + "." + month
        binding = movie.poster.bind(to: moviePosterImageView, default: #imageLiteral(resourceName: "movie"))
        moviePosterImageView.clipsToBounds = true
    }
    
}
