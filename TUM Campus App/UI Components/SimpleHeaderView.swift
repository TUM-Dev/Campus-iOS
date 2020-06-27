//
//  LectureHeaderView.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 24.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class SimpleHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String) {
        self.titleLabel.text = title
    }
}
