//
//  StretchyHeaderCollectionViewFlowLayout.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 7.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class StretchyHeaderCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        layoutAttributes?.forEach { attributes in

            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {
                guard let collectionView = collectionView else { return }
                let contentOffSetY = collectionView.contentOffset.y

                if contentOffSetY < 0 {
                    let collectionWidth = collectionView.frame.width
                    let height = attributes.frame.height - contentOffSetY
                    attributes.frame = CGRect.init(x: 0, y: contentOffSetY, width: collectionWidth, height: height)
                }
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { true }
}
