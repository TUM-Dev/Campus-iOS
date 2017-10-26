//
//  PersonSearchResultTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/10/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class PersonSearchResultTableViewCell: CardTableViewCell {
    
    var binding: ImageViewBinding?

    override func setElement(_ element: DataElement) {
        binding = nil
        if let user = element as? UserData {
            binding = user.avatar.bind(to: avatarView, default: #imageLiteral(resourceName: "avatar"))
            nameLabel.text = user.name
        }
    }
    @IBOutlet weak var avatarView: UIImageView! {
        didSet {
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = avatarView.frame.width / 2
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
}
