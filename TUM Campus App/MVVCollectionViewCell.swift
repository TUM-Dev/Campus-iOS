//
//  MVVCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 09.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class MVVCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var label1: UILabel!
    
    
    func setElement(_ element: DataElement) {
        
        if let element = element as? Station {
            label1.text = element.name
        }
    }
    
    
}
