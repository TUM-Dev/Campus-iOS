//
//  Confirmation.swift
//  Campus-iOS
//
//  Created by David Lin on 21.01.23.
//

import Foundation

struct Confirmation: Decodable {
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case value = ""
    }
}
