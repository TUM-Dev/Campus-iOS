//
//  MVVCardCell.swift
//  Campus
//
//  Created by Tim Gymnich on 09.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class MVVCardCell: CardTableViewCell, MultipleDataElementsPresentable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    
    func setDataSource<T>(dataSource: T, id: Int) where T : UICollectionViewDataSource & UICollectionViewDelegate {
        collectionView.tag = id
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
}

