//
//  GradeCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 22.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class GradeCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var examinerLabel: UILabel!
    @IBOutlet private weak var lvNumberLabel: UILabel!
    @IBOutlet weak var modusLabel: UILabel!
    @IBOutlet private weak var blockView: UIView! {

        didSet {
            blockView.layer.cornerRadius = blockView.bounds.size.width / 2
            blockView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var gradeLabel: UILabel!

    func configure(grade: Grade) {
        selectionStyle = .none
        titleLabel.text = grade.title
        gradeLabel.text = grade.grade
        lvNumberLabel.text = grade.lvNumber
        examinerLabel.text = grade.examiner
        modusLabel.text = grade.modus
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
    }
}
