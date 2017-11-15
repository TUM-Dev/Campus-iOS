//
//  BookRentalCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 15.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class BookRentalCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var prolongLabel: UILabel!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    
    func setElement(_ element: DataElement) {
        if let rentalItem = element as? BookRental {
            titleLabel.text = rentalItem.title
            authorLabel.text = rentalItem.author
            deadlineLabel.text = rentalItem.deadline
            prolongLabel.text = rentalItem.prolong.rawValue // TODO: Remap to localized string when available
        }
    }
    
}
