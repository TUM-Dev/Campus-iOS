//
//  NewsTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var newsItem: News? {
        didSet {
            if let newsItem = newsItem {
                titleLabel.text = newsItem.title
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a - dd MMM, YYYY"
                dateLabel.text = dateFormatter.string(from: newsItem.date as Date)
                detailImageView.image = newsItem.image
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
