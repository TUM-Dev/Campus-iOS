//
//  MovieDetailHeader.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import AlamofireImage

final class MovieDetailHeader: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(viewModel: MovieDetailViewModel.Header) {
        if let imageURL = viewModel.imageURL {
            imageView.af.setImage(withURL: imageURL, placeholderImage: UIImage(named: "movie"), filter: RoundedCornersFilter(radius: 4), imageTransition: .crossDissolve(0.3))
        } else {
            imageView.image = UIImage(named: "movie")?.af.imageRounded(withCornerRadius: 4)
        }
        titleLabel.text = viewModel.title
    }
}
