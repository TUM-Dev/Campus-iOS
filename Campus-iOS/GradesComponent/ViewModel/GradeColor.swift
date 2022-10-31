//
//  GradeColor.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import SwiftUI

extension GradesViewModel {
    struct GradeColor {
        static func color(for grade: Double?) -> Color {
            guard let grade = grade else { return .init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) }
            switch grade {
            case 1.0..<1.4: return .init(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            case 1.4..<1.8: return .init(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
            case 1.8..<2.1: return .init(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
            case 2.1..<2.4: return .init(#colorLiteral(red: 0.9999201894, green: 0.9686740041, blue: 0.4901453257, alpha: 1))
            case 2.4..<2.8: return .init(#colorLiteral(red: 0.9999290109, green: 0.9333780408, blue: 0.4587783813, alpha: 1))
            case 2.8..<3.0: return .init(#colorLiteral(red: 0.9999423623, green: 0.8745500445, blue: 0.000174792207, alpha: 1))
            case 3.0..<3.4: return .init(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
            case 3.4..<3.8: return .init(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
            case 3.8..<4.0: return .init(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
            case       4.0: return .init(#colorLiteral(red: 0.9709290862, green: 0.5358461142, blue: 0, alpha: 1))
            case 4.1...5.0: return .init(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
            default: return .init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            }
        }
        
        static func color(for grade: Grade) -> Color {
            return color(for: Double(grade.grade.replacingOccurrences(of: ",", with: ".")))
        }
    }
}
