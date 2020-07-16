//
//  MovieDetailHeader.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Kingfisher

final class MovieDetailHeader: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(viewModel: MovieDetailViewModel.Header) {
        if let imageURL = viewModel.imageURL {
            let processor = RoundCornerImageProcessor(cornerRadius: 4)
            imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "movie"), options: [.transition(.fade(0.3)), .processor(processor)])
        } else {
            imageView.image = UIImage(named: "movie")?.imageRounded(withCornerRadius: 4)
        }
        titleLabel.text = viewModel.title
    }
}
