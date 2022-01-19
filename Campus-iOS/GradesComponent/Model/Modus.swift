//
//  Modus.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import Foundation

enum Modus: String, Decodable {
    case written = "Schriftlich"
    case graded = "Beurteilt/immanenter Prüfungscharakter"
    
    var short: String {
        switch self {
        case .written: return "Schriftlich"
        case .graded: return "Beurteilt"
        }
    }
}
