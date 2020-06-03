//
//  NewsspreadCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/2/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import AlamofireImage

final class NewsspreadCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(news: News) {
        if let imageURL = news.imageURL {
            imageView.af.setImage(withURL: imageURL)
        } else {
            imageView.image = #imageLiteral(resourceName: "avatar")
        }
    }
}
