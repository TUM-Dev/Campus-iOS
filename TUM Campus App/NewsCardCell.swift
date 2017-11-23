//
//  NewsCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

class NewsCardCell: CardTableViewCell, MultipleDataElementsPresentable {
    
    @IBOutlet var collectionView: IndexableCollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
}
