//
//  UICollectionViewDelegateThreeItemFlowLayout.swift
//  Campus
//
//  Created by Tim Gymnich on 08.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class UICollectionViewDelegateThreeItemVerticalFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {

    let margin: CGFloat = 20.0
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin/4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = floor(collectionView.frame.size.height / 3 - margin / 2)
        let width: CGFloat = floor(collectionView.frame.size.width * 0.8)
        
        return CGSize(width: width, height: height)
    }
    
}
