//
//  LocationStrategy.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 02.08.22.
//

import Foundation
import MapKit

struct LocationStrategy: WidgetRecommenderStrategy {
    
    // Distance in meters.
    private let CLOSE_DISTANCE: CLLocationDistance = 1000
    private let VERY_CLOSE_DISTANCE: CLLocationDistance = 250
    
    private let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }
    
    func getRecommendation() async throws -> [WidgetRecommendation] {
        
        let authorization = locationManager.authorizationStatus
        if authorization != .authorizedWhenInUse || authorization != .authorizedAlways {
            locationManager.requestWhenInUseAuthorization()
        }
        
        var recommendations: [WidgetRecommendation] = []
        for widget in CampusAppWidget.allCases {
            guard let priority = try? await priority(of: widget) else {
                continue
            }
            let recommendation = WidgetRecommendation(widget: widget, priority: priority)
            recommendations.append(recommendation)
        }
        
        return recommendations.filter { $0.priority > 0 }
    }
    
    private func priority(of widget: CampusAppWidget) async throws -> Int {
        
        var priority: Int = 0
        
        guard let location = locationManager.location else {
            throw RecommenderError.missingPermissions
        }
        
        switch widget {
            
        case .cafeteria:
            
            var locations = await getCafeteriaLocations()
            
            for distance in [CLOSE_DISTANCE, VERY_CLOSE_DISTANCE] {
                locations = locations.filter { $0.distance(from: location) <= distance }
                if !locations.isEmpty {
                    priority += 1
                }
            }
            
        case .studyRoom:
            
            var locations = await getStudyRoomLocations()
            
            for distance in [CLOSE_DISTANCE, VERY_CLOSE_DISTANCE] {
                locations = locations.filter { $0.distance(from: location) <= distance }
                if !locations.isEmpty {
                    priority += 1
                }
            }

        default:
            break
        }
        
        return priority
    }
    
    private func getCafeteriaLocations() async -> [CLLocation] {
        
        let service = CafeteriasService()
        
        do {
            let cafeterias = try await service.fetch(forcedRefresh: false)
            return cafeterias.map { $0.location.coordinate.location }
        } catch { }
        
        return []
    }
    
    private func getStudyRoomLocations() async -> [CLLocation] {
        
        var locations: [CLLocation] = []
        let service = StudyRoomsService()
        
        do {
            let response = try await service.fetch(forcedRefresh: false)
            
            guard let groups = response.groups else {
                return []
            }
            
            for group in groups {
                if let coordinate = group.coordinate {
                    locations.append(coordinate.location)
                }
            }
        } catch {}
        
        return locations
    }
}
