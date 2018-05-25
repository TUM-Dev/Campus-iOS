//
//  MenuDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 10.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class MenuDataSource: NSObject, UICollectionViewDataSource {
    
    let cellType: AnyClass = MenuCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateListFlowLayout()
    var data: [CafeteriaMenu] = []
    let cellReuseID = "MenuCardCell"
    let cardReuseID = "MenuCard"
    
    
    init(data: [CafeteriaMenu]) {
        self.data = data
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! MenuCollectionViewCell
        let dish = data[indexPath.row]
    
        
        cell.dishLabel.text = dish.details.nameWithEmojiWithoutAnnotations
        cell.dishDetailLabel.text = ""
        
        for description in dish.details.annotationDescriptions {
            if dish.details.annotationDescriptions.last != description {
                cell.dishDetailLabel.text!.append("\(description), ")
            } else {
                cell.dishDetailLabel.text!.append(description)
            }
        }

        if let priceValue = dish.price?.student {
            cell.priceLabel.text = String(format:"%.2f€", priceValue)
        } else {
            cell.priceLabel.text = ""
        }

        return cell
    }
    
}
