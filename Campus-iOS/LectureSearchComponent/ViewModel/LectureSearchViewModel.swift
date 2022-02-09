//
//  LectureSearchViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import Foundation

import Foundation
import Alamofire
import XMLCoder

class LectureSearchViewModel: ObservableObject {
    @Published var result: [Lecture] = []
    @Published var errorMessage: String = ""
    
    private let sessionManager = Session.defaultSession
    
    func fetch(searchString: String) {
        // activate only when more than 3 characters
        
        let endpoint = TUMOnlineAPI.lectureSearch(search: searchString)
        sessionManager.cancelAllRequests()
        let request = sessionManager.request(endpoint)
        request.responseDecodable(of: TUMOnlineAPIResponse<Lecture>.self, decoder: XMLDecoder()) { [weak self] response in
            guard !request.isCancelled else {
                // cancelAllRequests doesn't seem to cancel all requests, so better check for this explicitly
                return
            }
            self?.result = response.value?.rows ?? []

            if let result = self?.result, result.isEmpty {
                self?.errorMessage = NSString(format: "Unable to find lecture".localized as NSString, searchString) as String
            } else {
                self?.errorMessage = ""
            }
        }
    }
}
