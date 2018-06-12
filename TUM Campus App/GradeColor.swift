//
//  gradeColor.swift
//  Campus
//
//  Created by Till on 12.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit

enum GradeColor : String {
    
    case grade_1_0
    case grade_1_3
    case grade_1_4
    case grade_1_7
    case grade_2_0
    case grade_2_3
    case grade_2_4
    case grade_2_7
    case grade_3_0
    case grade_3_3
    case grade_3_4
    case grade_3_7
    case grade_4_0
    case grade_4_3
    case grade_4_4
    case grade_4_7
    case grade_5_0
    case unknown
    
    var colorValue: UIColor {
        switch self {
        case .grade_1_0:
            return UIColor(hexString: "#318f11")
        case .grade_1_3:
            return UIColor(hexString: "#5dab12")
        case .grade_1_4:
            return UIColor(hexString: "#5dab12")
        case .grade_1_7:
            return UIColor(hexString: "#86c415")
        case .grade_2_0:
            return UIColor(hexString: "#c6e618")
        case .grade_2_3:
            return UIColor(hexString: "#ede003")
        case .grade_2_4:
            return UIColor(hexString: "#ede003")
        case .grade_2_7:
            return UIColor(hexString: "#fddf18")
        case .grade_3_0:
            return UIColor(hexString: "#fdbf19")
        case .grade_3_3:
            return UIColor(hexString: "#fcad18")
        case .grade_3_4:
            return UIColor(hexString: "#fcad18")
        case .grade_3_7:
            return UIColor(hexString: "#fb6515")
        case .grade_4_0:
            return UIColor(hexString: "#d50000")
        case .grade_4_3:
            return UIColor(hexString: "#c62828")
        case .grade_4_4:
            return UIColor(hexString: "#c62828")
        case .grade_4_7:
            return UIColor(hexString: "#b71c1c")
        case .grade_5_0:
            return UIColor(hexString: "#000000")
        default:
            return UIColor(hexString: "#a5a5a5")
        }
    }
    
}
