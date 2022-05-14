//
//  AcademicDegree.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 19.03.22.
//

import Foundation

enum AcademicDegree: String {
    case PhD = "Doctor of Philosophy"
    case BE = "Bachelor of Education"
    case ME = "Master of Education"
    case BSc = "Bachelor of Science"
    case MSc = "Master of Science"
    case MBA = "Master of Business Administration"
    case BA = "Bachelor of Arts"
    case MA = "Master of Arts"
    case MBD = "Master Brewer Diploma"
    case BECE = "Bachelor of Engineering in Chemical Engineering"
    case BEEDE = "Bachelor of Engineering in Electronics and Data Engineering"
    case unknown = ""
    
    var short: String {
        switch self {
        case .PhD: return "Ph.D."
        case .BE: return "BEd."
        case .ME: return "MEd."
        case .BSc: return "BSc."
        case .MSc: return "MSc."
        case .MBA: return "MBA"
        case .BA: return "B.A."
        case .MA: return "M.A."
        case .MBD: return "M.B.D."
        case .BECE: return "B.Eng. ChE."
        case .BEEDE: return "B.Eng. EDE."
        case .unknown: return ""
        }
    }
}
