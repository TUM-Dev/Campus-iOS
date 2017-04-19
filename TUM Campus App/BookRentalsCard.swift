//
//  BookRentalsCard.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 19.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class BookRentalsCardCell: CardTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var prolongLabel: UILabel!
    
    override func setElement(_ element: DataElement) {
        if let rentalItem = element as? BookRental {
            titleLabel.text = rentalItem.title
            authorLabel.text = rentalItem.author
            deadlineLabel.text = rentalItem.deadline
            prolongLabel.text = rentalItem.prolong
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
