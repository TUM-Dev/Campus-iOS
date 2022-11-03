//
//  MLModelDataHandler.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 28.09.22.
//

import Foundation
import MapKit
import CoreML
import TabularData

#if !targetEnvironment(simulator)
import CreateML
#endif

class AnalyticsDataHandler {
    
    private var discretizedData: [DiscretizedAppUsageDataEntity]?
    
    private let locationGroupRadius: CLLocationDistance
    
    private let timeNearbyThreshold: Int
    
    private let dateNearbyThreshold: Int
    
    private let modelIterations: Int
    
    private let minGroupSize: Int
    
    // Centroid : Identifier
    private var discretizedLocations: Dictionary<CLLocation, String> = [:]
    
    // Average Time : Identifier
    private var discretizedTimes: Dictionary<Date.Time, String> = [:]
    
    // Average Date : Identifier
    private var discretizedDates: Dictionary<Date, String> = [:]
    
    // Discrete value for any variable that is not close enough to any entry in the domain of the  respective discretized variable.
    private let otherValue = "other"
    
    init(data: [AppUsageDataEntity], locationGroupRadius: CLLocationDistance, timeNearbyThreshold: Int, dateNearbyThreshold: Int, modelIterations: Int = 20, minGroupSize: Int = 5) {
        self.locationGroupRadius = locationGroupRadius
        self.timeNearbyThreshold = timeNearbyThreshold
        self.dateNearbyThreshold = dateNearbyThreshold
        self.modelIterations = modelIterations
        self.minGroupSize = minGroupSize
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
        
        guard
            let min = keys.min(by: { location.distance(from: $0) < location.distance(from: $1)}),
            let value = discretizedLocations[min],
            location.distance(from: min) <= locationGroupRadius,
            !location.isInvalid()
        else { return otherValue }
        
        return value
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
    
    public func getPredictions(model: MLModel, parameters: [Covariate:String], dependentVariable: Covariate = .view) throws -> [CampusAppView:Double] {
        
        let inputParameters = Dictionary(uniqueKeysWithValues: parameters.map{ ($0.rawValue, $1) })
        
        guard let prediction = try? model.prediction(from: MLDictionaryFeatureProvider(dictionary: inputParameters)),
              let resultDict = prediction.featureValue(for: "\(dependentVariable.rawValue)Probability") else {
            throw RecommenderError.impossiblePrediction
        }
        
        var result: [CampusAppView:Double] = [:]
        
        try resultDict.dictionaryValue.forEach { view, probability in
            guard let view = CampusAppView(rawValue: view as? String ?? "") else {
                throw RecommenderError.badRecommendation
            }
            result[view] = probability.doubleValue
        }
        
        return result
    }
    
#if !targetEnvironment(simulator)
    
    public func dataTable(from data: [DiscretizedAppUsageDataEntity]? = nil) throws -> MLDataTable {
        
        guard let data = try? data ?? getData() else {
            throw RecommenderError.missingData
        }
        
        let dataDictionary: Dictionary = [
            Covariate.location.rawValue: data.map{ $0.location },
            Covariate.time.rawValue: data.map{ $0.time },
            Covariate.date.rawValue: data.map{ $0.date },
            Covariate.view.rawValue: data.map{ $0.view }
        ]
        
        return try MLDataTable(dictionary: dataDictionary)
    }
    
    public func evaluateClassifier(trainingData: MLDataTable, testData: MLDataTable, maxIterations: Int) throws -> Double {
        let classifier = try getClassifier(from: trainingData, maxIterations: maxIterations)
        let metrics = classifier.evaluation(on: testData)
        let accuracy = 1 - metrics.classificationError
        
        return accuracy
    }
    
    public func getModel(from trainingData: MLDataTable? = nil, maxIterations: Int? = nil) throws -> MLModel {
        let iterations = maxIterations ?? self.modelIterations
        return try getClassifier(from: trainingData, maxIterations: iterations).model
    }
    
    private func getClassifier(from trainingData: MLDataTable? = nil, maxIterations: Int? = nil) throws -> MLLogisticRegressionClassifier {
        let iterations = maxIterations ?? self.modelIterations
        let params = MLLogisticRegressionClassifier.ModelParameters(maxIterations: iterations)
        let data = try trainingData ?? dataTable()
                
        guard let classifier = try? MLLogisticRegressionClassifier(trainingData: data, targetColumn: Covariate.view.rawValue, parameters: params) else {
            throw RecommenderError.modelCreationFailed
        }
        
        return classifier
    }
#endif
    
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
            
            guard let view = entry.view, let startTime = entry.startTime, let endTime = entry.endTime else {
                return nil
            }
            
            return DiscretizedAppUsageDataEntity(
                location: discreteValue(for: CLLocation(latitude: entry.latitude, longitude: entry.longitude)),
                time: discreteValue(for: startTime.time),
                date: discreteValue(for: endTime),
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
        
        let groupedLocations = locations.groups(where: { $0.distance(from: $1) <= locationGroupRadius }, minGroupSize: minGroupSize)
        
        // Remove duplicate groups.
        return Array(Set(groupedLocations))
    }
    
    private func groupedTimes(from data: [AppUsageDataEntity]) -> [[Date.Time]] {
        let times = data.compactMap { $0.startTime?.time }
        let result = times.groups(where: { Date.Time.minutesBetween($0, $1) <= timeNearbyThreshold }, minGroupSize: minGroupSize)
        
        // Remove duplicate groups.
        return Array(Set(result))
    }
    
    private func groupedDates(from data: [AppUsageDataEntity]) -> [[Date]] {
        let dates = data.compactMap { $0.startTime }
        let result = dates.groups(where: { Calendar.current.dateComponents([.day], from: $0, to: $1).day! <= dateNearbyThreshold }, minGroupSize: minGroupSize)
        
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

// The model covariates (and the dependent variable).
enum Covariate: String {
    case location = "location", time = "time", date = "date", view = "view"
}
