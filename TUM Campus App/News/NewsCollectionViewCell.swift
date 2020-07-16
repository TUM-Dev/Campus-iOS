//
//  NewsCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 13.6.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static private let placeholder = UIImage(named: "placeholder")
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    func configure(news: News) {
        if let url = news.imageURL {
            imageView.kf.setImage(with: url, placeholder: NewsCollectionViewCell.placeholder, options: [.transition(.fade(0.3))])
        } else {
            imageView.image = NewsCollectionViewCell.placeholder
        }
        if let date = news.date {
            dateLabel.isHidden = false
            dateLabel.text = NewsCollectionViewCell.dateFormatter.string(from: date)
        } else {
            dateLabel.text = nil
            dateLabel.isHidden = true
        }
        titleLabel.text = news.title
    }

    override func prepareForReuse() {
        imageView.image = nil
    }

}
