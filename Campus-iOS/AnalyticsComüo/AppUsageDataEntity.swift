//
//  AppUsageDataEntity.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 10.09.22.
//

import Foundation
import CoreData

extension AppUsageDataEntity {
    
    convenience init(data: AppUsageData, context: NSManagedObjectContext) throws {
        
        guard let view = data.getView()?.rawValue,
              let startTime = data.getStartTime(),
              let endTime = data.getEndTime() else {
            throw AnalyticsError.missingValues
        }
        
        self.init(context: context)
        self.view = view
        self.startTime = startTime
        self.endTime = endTime
        self.latitude = data.getLatitude() ?? AppUsageData.invalidLocation
        self.longitude = data.getLongitude() ?? AppUsageData.invalidLocation
    }
}
