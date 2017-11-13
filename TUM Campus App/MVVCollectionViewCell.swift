//
//  MVVCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 09.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class MVVCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var numberLabel: BorderedLabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func setElement(_ element: DataElement) {
        
        if let element = element as? Station {
            //Just random data todo: fix this
            destinationLabel.text = element.place
            numberLabel.text = String(describing: element.id)
            timeLabel.text = String(describing: element.distance!)
        }
    }
    
}
