//
//  Modus.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 24.12.21.
//

import Foundation

// Not currently is use, as we don't know if this list is exhaustive
enum Modus: String, Decodable {
    case written = "Schriftlich"
    case graded = "Beurteilt/immanenter Prüfungscharakter"
    case wirrtenAndVerbal = "Schriftlich und Mündlich"
    case verbal = "Mündlich"
    
    var short: String {
        switch self {
        case .written: return "Schriftlich"
        case .graded: return "Beurteilt"
        case .wirrtenAndVerbal: return "Schriftlich/Mündlich"
        case .verbal: return "Mündlich"
        }
    }
}
