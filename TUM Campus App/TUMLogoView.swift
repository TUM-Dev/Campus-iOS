//
//  TUMLogoView.swift
//  Campus
//
//  Created by Tim Gymnich on 16.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class TUMLogoView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func tumLogoTap(sender: AnyObject) {
        imageView.image = #imageLiteral(resourceName: "logo-rainbow")
    }
    
    override func awakeFromNib() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tumLogoTap(sender:)))
        gestureRecognizer.numberOfTapsRequired = 3
        addGestureRecognizer(gestureRecognizer)
    }
}
