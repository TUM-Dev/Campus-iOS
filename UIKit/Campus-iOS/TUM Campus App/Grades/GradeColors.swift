//
//  GradeColors.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 17.10.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

struct GradeColor {

    static func color(for grade: Double?) -> UIColor {
        guard let grade = grade else { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
        switch grade {
        case 1.0..<1.4: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case 1.4..<1.8: return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case 1.8..<2.1: return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 2.1..<2.4: return #colorLiteral(red: 0.9999201894, green: 0.9686740041, blue: 0.4901453257, alpha: 1)
        case 2.4..<2.8: return #colorLiteral(red: 0.9999290109, green: 0.9333780408, blue: 0.4587783813, alpha: 1)
        case 2.8..<3.0: return #colorLiteral(red: 0.9999423623, green: 0.8745500445, blue: 0.000174792207, alpha: 1)
        case 3.0..<3.4: return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case 3.4..<3.8: return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case 3.8..<4.0: return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case 4.0...5.0: return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        default: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}
