//
//  CafeteriaMenuCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 22.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class CafeteriaMenuCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var label1: UILabel!
    
    
    func setElement(_ element: DataElement) {
        if let menu = element as? CafeteriaMenu {
            //            cafeteriaLabel.text = cafeteria.name
            //            let items = cafeteria.getMenusForDate(Date()).filter { (item) in
            //                return item.id != "0"
            //            }
            //            var string = ""
            //            for item in items {
            //                string += "\u{2022} " + item.name + "\n"
            //            }
            //            itemsLabel.text = string
        }
    }
    
}
