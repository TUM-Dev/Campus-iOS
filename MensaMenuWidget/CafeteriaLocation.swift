//
//  CafeteriaLocation.swift
//  TUM Campus App
//
//  Created by Nikolai Madlener on 12.12.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import Foundation

public enum CafeteriaLocation: String {
    case mensa_arcisstr
    case mensa_garching
    case mensa_leopoldstr
    case mensa_lothstr
    case mensa_martinsried
    case mensa_pasing
    case mensa_weihenstephan
    
    func mensaApiKey() -> String {
        switch self {
        case .mensa_arcisstr:
            return "mensa-arcisstr"
        case .mensa_garching:
            return "mensa-garching"
        case .mensa_leopoldstr:
            return "mensa-leopoldstr"
        case .mensa_lothstr:
            return "mensa-lothstr"
        case .mensa_martinsried:
            return "mensa-martinsried"
        case .mensa_pasing:
            return "mensa-pasing"
        case .mensa_weihenstephan:
            return "mensa_weihenstephan"
        }
    }
    
    func name() -> String {
        switch self {
        case .mensa_arcisstr:
            return "Mensa Arcisstraße"
        case .mensa_garching:
            return "Mensa Garching"
        case .mensa_leopoldstr:
            return "Mensa Leopoldstraße"
        case .mensa_lothstr:
            return "Mensa Lothstraße"
        case .mensa_martinsried:
            return "Mensa Martinsried"
        case .mensa_pasing:
            return "Mensa Pasing"
        case .mensa_weihenstephan:
            return "Mensa Weihenstephan"
        }
    }
}
