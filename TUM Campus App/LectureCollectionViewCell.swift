//
//  LectureCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 11.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//


import UIKit


class LectureCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var lectureNameLabel: UILabel!
    @IBOutlet weak var lectureTypeLabel: CircularLabel!
    
    
    func setElement(_ element: DataElement) {
        
        if let element = element as? Lecture {
            lectureNameLabel.text = element.name
            semesterLabel.text = element.semester
            lectureTypeLabel.text = String(describing: element.type.first ?? "?")
        }
    }
    
}
