//
//  NewsTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    var binding: ImageViewBinding?
    
    var newsItem: News? {
        didSet {
            binding = nil
            if let newsItem = newsItem {
                titleLabel.text = newsItem.title
                dateLabel.text = newsItem.date.string(using: "hh:mm a - dd MMM, YYYY")
                binding = newsItem.image.bind(to: detailImageView, default: nil)
            }
        }
    }

}
