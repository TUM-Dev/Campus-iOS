//
//  RoomFinderViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 17.05.22.
//

import Foundation
import Alamofire
import XMLCoder

@MainActor
class RoomFinderViewModel: ObservableObject {
    @Published var result: [FoundRoom] = []
    @Published var errorMessage: String = ""
    
    func fetch(for query: String, forcedRefresh: Bool = false) async {
        guard !query.isEmpty else {
            self.errorMessage = ""
            return
        }
        
        do {
            self.result = try await MainAPI.makeRequest(endpoint: TUMCabeAPI.roomSearch(query: query))
            self.errorMessage = ""
        } catch {
            print(error)
            self.errorMessage = NSString(format: "Unable to find room".localized as NSString, query) as String
        }
    }
}
