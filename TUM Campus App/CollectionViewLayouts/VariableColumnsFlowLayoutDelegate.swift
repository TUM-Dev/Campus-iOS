//
//  VariableColumnsFlowLayout.swift
//  Campus
//
//  Created by Till on 30.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class VariableColumnsFlowLayoutDelegate: ColumnsFlowLayoutDelegate {
    
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
