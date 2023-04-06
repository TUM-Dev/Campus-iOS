//
//  ProfileService.swift
//  Campus-iOS
//
//  Created by David Lin on 22.01.23.
//

import Foundation
import SwiftUI
import UIKit

struct ProfileService {
    func fetch(token: String, forcedRefresh: Bool) async throws -> Profile? {
        let response : TUMOnlineAPI.Response<Profile> = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.identify, token: token, forcedRefresh: forcedRefresh)
        
        return response.row.first
    }
    
    func fetch(token: String, forcedRefresh: Bool) async throws -> Tuition? {
        let response : TUMOnlineAPI.Response<Tuition> = try await MainAPI.makeRequest(endpoint: TUMOnlineAPI.tuitionStatus, token: token, forcedRefresh: forcedRefresh)
        
        return response.row.first
    }
    
    struct superImage: Decodable {
        let value: Image?
        
        enum CodingKeys: String, CodingKey {
            case imageData = ""
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let imageString = try container.decodeIfPresent(String.self, forKey: .imageData), let imageData = Data(base64Encoded: imageString, options: [.ignoreUnknownCharacters]), let uiImage = UIImage(data: imageData) {
                self.value = Image(uiImage: uiImage)
            } else {
                self.value = nil
            }
        }
    }
}
