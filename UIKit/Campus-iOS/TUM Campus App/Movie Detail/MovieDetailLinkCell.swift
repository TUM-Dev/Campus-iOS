//
//  MovieDetailLinkCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class MovieDetailLinkCell: UICollectionViewCell {
    private let seperatorView = UIView()
    @IBOutlet private weak var nameLabel: UILabel!


    func configure(viewModel: MovieDetailViewModel.LinkCell, isLastCell: Bool = false) {
        nameLabel.text = viewModel.name

        seperatorView.isHidden = isLastCell
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = .separator
        contentView.addSubview(seperatorView)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

}
