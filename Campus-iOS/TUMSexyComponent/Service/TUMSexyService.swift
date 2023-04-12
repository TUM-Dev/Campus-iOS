//
//  TUMSexyService.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import Foundation

struct TUMSexyService: ServiceProtocol {
    typealias T = TUMSexyLink
    
    func fetch(forcedRefresh: Bool) async throws -> [TUMSexyLink] {
        let response: [String : TUMSexyLink] = try await MainAPI.makeRequest(endpoint: TUMSexyAPI.standard, forcedRefresh: forcedRefresh)
        
        var links = [TUMSexyLink]()
        response.values.forEach {
            if $0.target != nil && $0.description != nil {
                links.append($0)
            }
        }
        
        return links
    }
}
