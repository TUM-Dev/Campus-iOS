//
//  Analytics.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 16.08.22.
//

import Foundation
import MapKit
import SwiftUI

struct AnalyticsController {
    
    @AppStorage("analyticsOptIn") private static var didOptIn = false
    
    static func store(entry: AppUsageData) {
        if let _ = try? AppUsageDataEntity(data: entry, context: PersistenceController.shared.container.viewContext) {
            PersistenceController.shared.save()
        }
    }
    
    static func getEntries() throws -> [AppUsageDataEntity] {
        let request = AppUsageDataEntity.fetchRequest()
        guard let data = try? PersistenceController.shared.container.viewContext.fetch(request) else {
            throw AnalyticsError.fetchFailed
        }
        
        return data
    }
    
    static func upload(entry: AppUsageData) async throws {
        
        print("Info: app usage data upload is disabled.")
        return
        
        if !didOptIn {
            return
        }
        
        guard let postToken = Bundle.main.object(forInfoDictionaryKey: "ANALYTICS_POST_TOKEN") as? String, !postToken.isEmpty,
                let analyticsApi = Bundle.main.object(forInfoDictionaryKey: "ANALYTICS_API") as? String else {
            return
        }
                
        guard var components = URLComponents(string: "https://" + analyticsApi) else {
            return
        }
        
        /* Query items */
        
        guard let deviceIdentifier = await UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
                
        guard let startDate = entry.getStartTime(), let endDate = entry.getEndTime(), let view = entry.getView() else {
            return
        }
        
        let latitude = entry.getLatitude() ?? AppUsageData.invalidLocation.coordinate.latitude
        let longitude = entry.getLongitude() ?? AppUsageData.invalidLocation.coordinate.longitude
        
        let hashedId = HashFunction.sha256(deviceIdentifier)
        let formatter = DateFormatter()
        formatter.dateFormat = "YY-MM-dd HH-mm-ss"
        let startTime = formatter.string(from: startDate)
        let endTime = formatter.string(from: endDate)
        
        components.queryItems = [
            URLQueryItem(name: "user_id", value: hashedId),
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "start_time", value: startTime),
            URLQueryItem(name: "end_time", value: endTime),
            URLQueryItem(name: "view", value: view.rawValue)
        ]
        
        guard let url = components.url else {
            return
        }
        
#if targetEnvironment(simulator)
        print("🟢 Query items:")
        print(components.queryItems ?? [])
        return
#endif

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(postToken, forHTTPHeaderField: "Authorization")

        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
