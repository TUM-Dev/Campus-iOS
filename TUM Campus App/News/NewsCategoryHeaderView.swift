//
//  NewsCategoryHeaderView.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 14.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class NewsCategoryHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(source: NewsSource) {
        self.titleLabel.text = source.title
    }
}
