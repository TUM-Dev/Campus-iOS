//
//  NewsspreadCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/2/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class NewsspreadCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(news: News) {
        if let imageURL = news.imageURL {
            imageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "avatar"), options: [.transition(.fade(0.2))])
        } else {
            imageView.image = #imageLiteral(resourceName: "avatar")
        }
    }
}
