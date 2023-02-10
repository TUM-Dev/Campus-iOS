//
//  ServiceProtocols.swift
//  Campus-iOS
//
//  Created by David Lin on 20.01.23.
//

import Foundation

protocol ServiceTokenProtocol {
    associatedtype T : Decodable
    func fetch(token: String, forcedRefresh: Bool) async throws -> [T]
}

protocol ServiceProtocol {
    associatedtype T : Decodable
    func fetch(forcedRefresh: Bool) async throws -> [T]
}
