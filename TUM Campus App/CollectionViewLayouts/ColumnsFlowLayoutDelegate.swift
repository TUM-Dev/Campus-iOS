//
//  ColumnsFlowLayout.swift
//  Campus
//
//  Created by Till on 30.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

/**
 This abstract class provides the size of a UICollectionView's items and delegates selection
 events to a TUMInteractiveDataSource.
 */
class ColumnsFlowLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    let delegate: TUMInteractiveDataSource?
    let margin: CGFloat = 20.0
    
    var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isPortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
    /**
     Determines the number of columns to display, which depends on the device type and the device
     orientation.
     */
    var columns: Int {
        if isPhone {
            return 1
        } else if isPortrait {
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
