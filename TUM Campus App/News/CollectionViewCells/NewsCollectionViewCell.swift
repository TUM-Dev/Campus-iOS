//
//  NewsCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/2/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var sourceImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(_ news: News) {
        if let sourceImageURL = news.source?.icon {
            imageView.kf.setImage(with: sourceImageURL, placeholder: #imageLiteral(resourceName: "logo-rainbow"), options: [.transition(.fade(0.2))])
        } else {
            sourceImageView.image = #imageLiteral(resourceName: "logo-rainbow")
        }
        if let imageURL = news.imageURL {
            imageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "avatar"), options: [.transition(.fade(0.2))])
        } else {
            imageView.image = #imageLiteral(resourceName: "avatar")
        }
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        titleLabel.text = news.title ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        if let date = news.date {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
    }
    
}
