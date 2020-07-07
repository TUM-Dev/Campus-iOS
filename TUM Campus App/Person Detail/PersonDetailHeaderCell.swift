//
//  PersonDetailHeaderCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import AlamofireImage

final class PersonDetailHeaderCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func configure(viewModel: PersonDetailViewModel.Header) {
        if let image = viewModel.image {
            imageView.image = image.af.imageRoundedIntoCircle()
        } else if let imageURL = viewModel.imageURL {
            imageView.af.setImage(withURL: imageURL, placeholderImage: UIImage(systemName: "person.crop.circle.fill"), filter: CircleFilter(), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3))
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        nameLabel.text = viewModel.name
    }
}
