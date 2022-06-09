//
//  RoomFinderViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 17.05.22.
//

import Foundation
import Alamofire
import XMLCoder

class RoomFinderViewModel: ObservableObject {
    @Published var result: [FoundRoom] = []
    @Published var errorMessage: String = ""
    
    private let sessionManager = Session.defaultSession
    
    func fetch(searchString: String) {
        guard !searchString.isEmpty else {
            sessionManager.cancelAllRequests()
            self.errorMessage = ""
            return
        }
        
        let endpoint = TUMCabeAPI.roomSearch(query: searchString)
        sessionManager.cancelAllRequests()
        let request = sessionManager.request(endpoint)
        request.responseDecodable(of: [FoundRoom].self, decoder: JSONDecoder()) { [weak self] response in
            guard !request.isCancelled else {
                // cancelAllRequests doesn't seem to cancel all requests, so better check for this explicitly
                return
            }

            self?.result = response.value ?? []

            if let result = self?.result, result.isEmpty {
                self?.errorMessage = NSString(format: "Unable to find room".localized as NSString, searchString) as String
            } else {
                self?.errorMessage = ""
            }
        }
    }
}
