//
//  FixedColumnsVerticalItemsFlowLayout.swift
//  Campus
//
//  Created by Till on 30.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

/**
 This class subclasses ColumnsFlowLayoutDelegate and provides the size of a UICollectionView's
 items that contain vertically-arranged content. It uses a fixed height and computes the item
 width based on the number of columns, which depends on the device type and orientation.
 */
class FixedColumnsVerticalItemsFlowLayoutDelegate: ColumnsFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin / 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // We work with 80 percent of the UICollectionView's frame width because we want to show the
        // next element to indicate swipe-ability.
        let width: CGFloat = floor(collectionView.frame.size.width * 0.8 / CGFloat(columns))
        let height: CGFloat = floor(collectionView.frame.size.height / 3 - margin / 2)
        return CGSize(width: width, height: height)
    }

}
