//
//  NewsCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class NewsCardCell: CardTableViewCell {
    
    override func setElement(_ element: DataElement) {
        if let newsItem = element as? News {
            titleLabel.text = newsItem.title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a - dd MMM, YYYY"
            dateLabel.text = dateFormatter.string(from: newsItem.date as Date)
            detailImageView.image = newsItem.image
        }
    }
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            backgroundColor = UIColor.clear
            cardView.layer.shadowOpacity = 0.4
            cardView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
