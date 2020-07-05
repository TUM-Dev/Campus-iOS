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
    private let seperatorView = UIView()

    func configure(viewModel: PersonDetailViewModel.Header, isLastCell: Bool = false) {
        seperatorView.isHidden = isLastCell
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = .separator
        contentView.addSubview(seperatorView)

        if let image = viewModel.image {
            imageView.image = image.af.imageRoundedIntoCircle()
        } else if let imageURL = viewModel.imageURL {
            imageView.af.setImage(withURL: imageURL, placeholderImage: UIImage(systemName: "person.crop.circle.fill"), filter: CircleFilter(), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3))
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        nameLabel.text = viewModel.name

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
