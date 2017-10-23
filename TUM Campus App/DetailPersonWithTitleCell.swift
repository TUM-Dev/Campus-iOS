//
//  DetailPersonWithTitleCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/24/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class DetailPersonWithTitleCell: CardTableViewCell {
    
    var binding: ImageViewBinding?

    override func setElement(_ element: DataElement) {
        if let user = element as? UserData {
            binding = user.avatar.bind(to: avatarView, default: #imageLiteral(resourceName: "avatar"))
            nameLabel.text = user.name
            titleLabel.text = user.title
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = nil
        }
    }
    
    @IBOutlet weak var avatarView: UIImageView! {
        didSet {
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = avatarView.frame.width / 2
        }
    }
}
