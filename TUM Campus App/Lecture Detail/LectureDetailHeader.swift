//
//  LectureDetailHeader.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 6.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class LectureDetailHeader: UICollectionViewCell {
    private let seperatorView = UIView()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func configure(viewModel: LectureDetailViewModel.Header, isLastCell: Bool = false) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

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
