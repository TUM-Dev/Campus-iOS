//
//  MenuDataSource.swift
//  Campus
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
