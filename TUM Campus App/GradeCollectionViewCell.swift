//
//  GradeCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 11.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class GradeCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var label1: UILabel!
    
    
    func setElement(_ element: DataElement) {
        
        if let element = element as? Grade {
            label1.text = element.name
        }
    }
    
}

