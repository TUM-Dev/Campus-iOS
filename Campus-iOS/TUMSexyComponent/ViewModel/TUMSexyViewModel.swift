//
//  TUMSexyLink.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import Foundation

@MainActor
class TUMSexyViewModel: ObservableObject {
    @Published var state: APIState<[TUMSexyLink]> = .na
    @Published var hasError: Bool = false
    
    let service = TUMSexyService()
    
    func getLinks(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            self.state = .success(
                data: try await service.fetch(forcedRefresh: forcedRefresh)
            )
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
