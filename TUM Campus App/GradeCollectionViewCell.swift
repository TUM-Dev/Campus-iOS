//
//  GradeCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 11.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class GradeCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
    func setElement(_ element: DataElement) {
        
        if let element = element as? Grade {
            lectureLabel.text = element.name
            semesterLabel.text = element.semester
            gradeLabel.text = element.result
           
            let components = element.result.split(separator: ",")
            let gradeComponents = (components[0],components[1])
            
            switch gradeComponents {
                
                //This is a fucking hack pls fix
            case ("1",_): gradeLabel.textColor = .green
            case ("2",_): gradeLabel.textColor = .green
            case ("3",_): gradeLabel.textColor = .yellow
            case ("4",_): gradeLabel.textColor = .orange
            case ("5",_): gradeLabel.textColor = .red
            default: gradeLabel.textColor = .black

            }
           
        }
    }
    
}

