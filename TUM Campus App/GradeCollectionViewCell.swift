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
            case ("1",_): gradeLabel.textColor = #colorLiteral(red: 0.3068726243, green: 0.8835613666, blue: 0.4050915909, alpha: 1)
            case ("2",_): gradeLabel.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
            case ("3",_): gradeLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case ("4",_): gradeLabel.textColor = #colorLiteral(red: 1, green: 0.4494612679, blue: 0.1993430925, alpha: 1)
            case ("5",_): gradeLabel.textColor = #colorLiteral(red: 1, green: 0.02289205613, blue: 0.2721864875, alpha: 1)
            default: gradeLabel.textColor = .black

            }
           
        }
    }
    
}

