//
//  ColumnsFlowLayout.swift
//  Campus
//
//  Created by Till on 30.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class ColumnsFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    
    let delegate: TUMInteractiveDataSource?
    let margin: CGFloat = 20.0
    
    var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    var columns: CGFloat {
        if isPhone {
            return 1
        } else if !isLandscape {
            return 2
        } else {
            return 3
        }
    }
    
    init(delegate: TUMInteractiveDataSource? = nil) {
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.onItemSelected?(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }

}
