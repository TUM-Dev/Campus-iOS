//
//  FixedColumnsFlowLayout.swift
//  Campus
//
//  Created by Till on 30.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class FixedColumnsFlowLayoutDelegate: ColumnsFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 0.8 / CGFloat(columns)
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }

}
