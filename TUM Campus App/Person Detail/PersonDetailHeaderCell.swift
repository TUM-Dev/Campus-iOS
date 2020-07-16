//
//  PersonDetailHeaderCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Kingfisher

final class PersonDetailHeaderCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func configure(viewModel: PersonDetailViewModel.Header) {
        if let image = viewModel.image {
            imageView.image = image.imageRoundedIntoCircle()
        } else if let imageURL = viewModel.imageURL {
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: imageView.bounds.size.height / 2)
            imageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "person.crop.circle.fill"), options: [.transition(.fade(0.3)), .processor(processor)])
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        nameLabel.text = viewModel.name
    }
}
