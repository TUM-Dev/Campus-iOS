//
//  Token.swift
//  Campus-iOS
//
//  Created by David Lin on 21.01.23.
//

import Foundation

struct Token: Decodable {
    let value: String

    private enum CodingKeys: String, CodingKey {
        case value = ""
    }
}
