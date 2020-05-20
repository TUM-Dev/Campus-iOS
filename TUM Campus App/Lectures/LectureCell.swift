//
//  LectureTableViewCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 22.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class LectureCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }
}
