//
//  VariableColumnsFlowLayout.swift
//  Campus
//
//  Created by Till on 30.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

/**
 This class subclasses ColumnsFlowLayoutDelegate and provides the size of a UICollectionView's
 items. It uses a fixed height and computes the item width based on the aspect ratio of its
 content.
 */
class VariableColumnsFlowLayoutDelegate: ColumnsFlowLayoutDelegate {
    
    /**
     The width-to-height aspect ratio of the content
     */
    let aspectRatio: CGFloat
    
    init(aspectRatio: CGFloat, delegate: TUMInteractiveDataSource? = nil) {
        self.aspectRatio = aspectRatio
        super.init(delegate: delegate)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = floor(height * aspectRatio)
        return CGSize(width: width, height: height)
    }

}
