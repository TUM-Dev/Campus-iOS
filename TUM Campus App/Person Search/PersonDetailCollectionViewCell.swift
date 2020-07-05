//
//  PersonDetailCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class PersonDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    private let seperatorView = UIView()

    func configure(viewModel: PersonDetailViewModel.Cell, isLastCell: Bool = false) {
        seperatorView.isHidden = isLastCell
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = .separator
        contentView.addSubview(seperatorView)
        
        keyLabel.text = viewModel.key
        valueLabel.text = viewModel.value

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

}
