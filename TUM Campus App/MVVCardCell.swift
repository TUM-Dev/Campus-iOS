//
//  MVVCardCell.swift
//  Campus
//
//  Created by Tim Gymnich on 09.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class MVVCardCell: CardTableViewCell, MultipleDataElementsPresentable {
    
    @IBOutlet weak var collectionView: IndexableCollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!    
}

