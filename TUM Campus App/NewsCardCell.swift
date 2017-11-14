//
//  NewsCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

class NewsCardCell: CardTableViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var binding: ImageViewBinding?
    
    func setElement(_ element: DataElement) {
        binding = nil
        guard let newsItem = element as? News else { return }
        sourceLabel.text = newsItem.source.title
        sourceLabel.textColor = newsItem.source.titleColor
        titleLabel.text = newsItem.title
        dateLabel.text = newsItem.date.string(using: "dd MMM, YYYY, hh:mm a")
        binding = newsItem.image.bind(to: detailImageView, default: nil)
    }

}
