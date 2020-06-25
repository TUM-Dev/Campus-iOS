//
//  GradeCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 25.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class GradeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var examinerLabel: UILabel!
    @IBOutlet private weak var lvNumberLabel: UILabel!
    @IBOutlet private weak var modusLabel: UILabel!
    @IBOutlet private weak var blockView: UIView!
    @IBOutlet private weak var gradeLabel: UILabel!

    private let seperatorView = UIView()

    func configure(grade: Grade, lastCell: Bool = false) {
        blockView.layer.cornerRadius = blockView.bounds.size.width / 2
        blockView.clipsToBounds = true

        seperatorView.isHidden = lastCell
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = .separator
        contentView.addSubview(seperatorView)

        titleLabel.text = grade.title
        gradeLabel.text = grade.grade
        lvNumberLabel.text = grade.lvNumber
        examinerLabel.text = grade.examiner
        modusLabel.text = grade.modus?.components(separatedBy: " ").first
        if let gradeValue = Double(grade.grade?.replacingOccurrences(of: ",", with: ".") ?? "") {
            switch gradeValue {
            case 1.0..<2.0:
                blockView.backgroundColor = UIColor.systemGreen
            case 2.0..<3.0:
                blockView.backgroundColor = UIColor.systemYellow
            case 3.0...4.0:
                blockView.backgroundColor = UIColor.systemOrange
            case 4.3...5.0:
                blockView.backgroundColor = UIColor.systemRed
            default:
                blockView.backgroundColor = UIColor.systemGray
            }
        }
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
