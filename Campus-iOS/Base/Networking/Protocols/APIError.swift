//
//  APIErrors.swift
//  Campus-iOS
//
//  Created by David Lin on 19.01.23.
//

import Foundation

protocol APIError: Error, Decodable {
    init(message: String)
}
