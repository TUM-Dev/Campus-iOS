//
//  NewsCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 02.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    
    var binding: ImageViewBinding?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
