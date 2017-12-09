//
//  IndexableCollectionView.swift
//  Campus
//
//  Created by Tim Gymnich on 22.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class IndexableCollectionView: UICollectionView {
    
    var index: IndexPath?
    @IBInspectable var cellWidth: CGFloat = -1
    @IBInspectable var cellHeight: CGFloat = 64
}
