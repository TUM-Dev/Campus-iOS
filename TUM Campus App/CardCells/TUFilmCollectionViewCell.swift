//
//  TUFilmCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 03.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class TUFilmCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var moviePosterImageView: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var binding: ImageViewBinding?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
