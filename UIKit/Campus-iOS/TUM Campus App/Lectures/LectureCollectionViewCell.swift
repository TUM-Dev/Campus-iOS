//
//  LectureCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 23.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class LectureCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var speakerLabel: UILabel!
    @IBOutlet private weak var eventType: UILabel!
    private let seperatorView = UIView()

    func configure(lecture: Lecture, lastCell: Bool = false) {
        titleLabel.text = lecture.title
        speakerLabel.text = lecture.speaker
        eventType.text = lecture.eventType

        seperatorView.isHidden = lastCell
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
