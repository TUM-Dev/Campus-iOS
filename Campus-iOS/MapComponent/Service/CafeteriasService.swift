//
//  CafeteriasServiceProtocol.swift
//  Campus-iOS
//
//  Created by David Lin on 14.05.22.
//

import Foundation

protocol CafeteriasServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Cafeteria]
}

struct CafeteriasService: CafeteriasServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Cafeteria] {
        return try await EatAPI.fetchCafeterias(forcedRefresh: forcedRefresh)
    }
}
