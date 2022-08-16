//
//  Analytics.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 16.08.22.
//

import Foundation
import MapKit

struct AnalyticsController {
    
    static func visitedView(view: CampusAppView) {
        let time = Date()
        
        guard let location = CLLocationManager().location else {
            return
        }
        
        let data = AppUsageData(context: PersistenceController.shared.container.viewContext)
        data.latitude = location.coordinate.latitude
        data.longitude = location.coordinate.longitude
        data.time = time
        data.view = view.rawValue
        
        PersistenceController.shared.save()
    }
}
