//
//  LectureDetailHeader.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 6.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class LectureDetailHeader: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func configure(viewModel: LectureDetailViewModel.Header) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
