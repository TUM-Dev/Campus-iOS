//
//  MovieCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/2/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import AlamofireImage

final class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(_ movie: Movie) {
        if let coverURL = movie.cover {
            imageView.af.setImage(withURL: coverURL)
        } else {
            imageView.image = #imageLiteral(resourceName: "movie")
        }
        titleLabel.text = movie.title ?? ""
    }
    
}
