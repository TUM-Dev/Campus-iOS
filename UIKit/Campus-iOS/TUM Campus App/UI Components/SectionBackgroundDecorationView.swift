//
//  SectionBackgroundDecoration.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 24.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    private func configure() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 12
    }
}
