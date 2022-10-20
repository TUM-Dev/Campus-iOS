//
//  MLModelDataHandler.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 28.09.22.
//

import Foundation
import MapKit

class MLModelDataHandler {
        
    private var discretizedData: [DiscretizedAppUsageDataEntity]?
    
    private let locationGroupRadius: CLLocationDistance
    
    private let timeNearbyThreshold: Int
    
    private let dateNearbyThreshold: Int
    
    // Centroid : Identifier
    private var discretizedLocations: Dictionary<CLLocation, String> = [:]
    
    // Average Time : Identifier
    private var discretizedTimes: Dictionary<Date.Time, String> = [:]
    
    // Average Date : Identifier
    private var discretizedDates: Dictionary<Date, String> = [:]
    
    // Discrete value for any variable that is not close enough to any entry in the domain of the  respective discretized variable.
    private let otherValue = "other"
    
    init(data: [AppUsageDataEntity], locationGroupRadius: CLLocationDistance, timeNearbyThreshold: Int, dateNearbyThreshold: Int) {
        self.locationGroupRadius = locationGroupRadius
        self.timeNearbyThreshold = timeNearbyThreshold
        self.dateNearbyThreshold = dateNearbyThreshold
        self.discretizedData = self.discretize(data)
    }
    
    public func getData() throws -> [DiscretizedAppUsageDataEntity] {
        guard let discretizedData else {
            throw RecommenderError.missingData
        }
        
        return discretizedData
    }
    
    public func discreteValue(for location: CLLocation) -> String {
        
        let keys = discretizedLocations.keys
        guard let min = keys.min(by: { location.distance(from: $0) < location.distance(from: $1)}) else {
            return otherValue
        }
        
        if location.distance(from: min) > locationGroupRadius || location.isInvalid()  {
            return otherValue
        }
        
        return discretizedLocations[min] ?? otherValue
    }
    
    public func discreteValue(for time: Date.Time) -> String {
        let keys = discretizedTimes.keys
        guard let min = keys.min(by: { Date.Time.minutesBetween(time, $0) < Date.Time.minutesBetween(time, $1) }) else {
            return otherValue
        }
        
        if Date.Time.minutesBetween(time, min) > timeNearbyThreshold {
            return otherValue
        }
        
        return discretizedTimes[min] ?? otherValue
    }
    
    public func discreteValue(for date: Date) -> String {
        let keys = discretizedDates.keys
        guard let min = keys.min(by: { Date.daysBetween(date, $0) < Date.daysBetween(date, $1) }) else {
            return otherValue
        }
        
        if Date.daysBetween(date, min) > dateNearbyThreshold {
            return otherValue
        }
        
        return discretizedDates[min] ?? otherValue
    }
    
    private func discretize(_ data: [AppUsageDataEntity]) -> [DiscretizedAppUsageDataEntity] {
        let locationGroups = groupedLocations(from: data)
        for group in locationGroups {
            let groupId = UUID().description
            self.discretizedLocations[centroid(of: group)] = groupId
        }
        
        let timeGroups = groupedTimes(from: data)
        for group in timeGroups {
            let groupId = UUID().description
            let middle = middleTime(of: group)
            self.discretizedTimes[middle] = groupId
        }
        
        let dateGroups = groupedDates(from: data)
        for group in dateGroups {
            let groupId = UUID().description
            let middle = middleDate(of: group)
            self.discretizedDates[middle] = groupId
        }
        
        let discretizedData: [DiscretizedAppUsageDataEntity] = data.compactMap { entry in
            
            guard let view = entry.view else {
                return nil
            }
            
            return DiscretizedAppUsageDataEntity(
                location: discreteValue(for: CLLocation(latitude: entry.latitude, longitude: entry.longitude)),
                time: discreteValue(for: entry.startTime?.time ?? Date().time),
                date: discreteValue(for: entry.startTime ?? Date()),
                view: view
            )
        }
        
        return discretizedData
    }
    
    private func centroid(of locations: [CLLocation]) -> CLLocation {
        let validLocations = locations.filter{ !$0.isInvalid() }
        let lat = validLocations.map{ $0.coordinate.latitude }.reduce(0.0, +) / Double(locations.count)
        let lon = validLocations.map{ $0.coordinate.longitude }.reduce(0.0, +) / Double(locations.count)
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    private func middleTime(of times: [Date.Time]) -> Date.Time {
        let sortedTimes = times.sorted{ $0 < $1 }
        let minTime = sortedTimes.first ?? Date().time
        let maxTime = sortedTimes.last ?? Date().time
        let difference = Date.Time.minutesBetween(minTime, maxTime)
        return minTime.date.addingTimeInterval(Double(difference * 60)).time
    }
    
    private func middleDate(of dates: [Date]) -> Date {
        let sortedDates = dates.sorted{ $0 < $1 }
        let minDate = sortedDates.first ?? Date()
        let maxDate = sortedDates.last ?? Date()
        let difference = Date.daysBetween(minDate, maxDate)
        return minDate.addingTimeInterval(Double(difference * 24 * 60 * 60))
    }
    
    private func groupedLocations(from data: [AppUsageDataEntity]) -> [[CLLocation]] {
        let locations: [CLLocation] = data.compactMap{ entry in
            let location =  CLLocation(latitude: entry.latitude, longitude: entry.longitude)
            return location.isInvalid() ? nil : location
        }
        
        let groupedLocations = locations.groups(where: { $0.distance(from: $1) <= locationGroupRadius })
        
        // Remove duplicate groups.
        return Array(Set(groupedLocations))
    }
    
    private func groupedTimes(from data: [AppUsageDataEntity]) -> [[Date.Time]] {
        let times = data.compactMap { $0.startTime?.time }
        var result = times.groups(where: { Date.Time.minutesBetween($0, $1) <= timeNearbyThreshold })
        
        // Remove duplicate groups.
        return Array(Set(result))
    }
    
    private func groupedDates(from data: [AppUsageDataEntity]) -> [[Date]] {
        let dates = data.compactMap { $0.startTime }
        var result = dates.groups(where: { Calendar.current.dateComponents([.day], from: $0, to: $1).day! <= dateNearbyThreshold })
        
        // Remove duplicate groups.
        return Array(Set(result))
    }
}

struct DiscretizedAppUsageDataEntity {
    let location: String
    let time: String
    let date: String
    let view: String
}
