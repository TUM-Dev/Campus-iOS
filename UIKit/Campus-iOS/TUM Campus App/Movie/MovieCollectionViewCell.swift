//
//  MovieCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 16.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static private let placeholder = UIImage(named: "movie")
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    func configure(movie: Movie) {
        if let url = movie.cover {
            imageView.kf.setImage(with: url, placeholder: MovieCollectionViewCell.placeholder, options: [.transition(.fade(0.3))])
        } else {
            imageView.image = MovieCollectionViewCell.placeholder
        }
        if let date = movie.date {
            dateLabel.isHidden = false
            dateLabel.text = MovieCollectionViewCell.dateFormatter.string(from: date)
        } else {
            dateLabel.text = nil
            dateLabel.isHidden = true
        }
        titleLabel.text = movie.title
    }

    override func prepareForReuse() {
        imageView.image = nil
    }

}
