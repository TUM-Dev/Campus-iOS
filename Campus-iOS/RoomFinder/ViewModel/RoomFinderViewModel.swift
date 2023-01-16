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
    
    private let sessionManager = Session.defaultSession
    
    func fetch(searchString: String) async {
        guard !searchString.isEmpty else {
            sessionManager.cancelAllRequests()
            self.errorMessage = ""
            return
        }
        
        do {
            self.result = try await MainAPI.makeRequest(endpoint: TUMCabeAPI2.roomSearch(query: searchString))
            self.errorMessage = ""
        } catch {
            print(error)
            self.errorMessage = NSString(format: "Unable to find room".localized as NSString, searchString) as String
        }
        
//        let endpoint = TUMCabeAPI.roomSearch(query: searchString)
//        sessionManager.cancelAllRequests()
//        let request = sessionManager.request(endpoint)
//        request.responseDecodable(of: [FoundRoom].self, decoder: JSONDecoder()) { [weak self] response in
//            guard !request.isCancelled else {
//                // cancelAllRequests doesn't seem to cancel all requests, so better check for this explicitly
//                return
//            }
//
//            self?.result = response.value ?? []
//
//            if let result = self?.result, result.isEmpty {
//                self?.errorMessage = NSString(format: "Unable to find room".localized as NSString, searchString) as String
//            } else {
//                self?.errorMessage = ""
//            }
//        }
    }
}
