//
//  AnalyticsStrategy.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 17.08.22.
//

import Foundation
import CoreData
import MapKit
import TabularData
import CoreML

#if !targetEnvironment(simulator)
import CreateML
#endif

class AnalyticsStrategy: WidgetRecommenderStrategy {
    
     
    /*
     * These values alter the domain of the covariates of the model.
     * The covariates are discretized into named groups.
     * Example: we might have multiple entries where the user visited the library.
     * The exact latitude and longitude values differ slightly, but we still consider
     * all of them to be one location (the library).
     */
    
    // The radius of a location group in meters.
    private let locationGroupRadius: CLLocationDistance = 100
    
    // The timespan for a time group in minutes.
    private let timeNearbyThreshold = 30
    
    // The timespan for a date group in days.
    private let dateNearbyThreshold = 15
    
    /* * */
        
    // The maximal amount of iterations to train the machine learning model.
    private let modelMaxIterations = 10
    
    // The model that is responsible for the predictions.
    private var model: MLModel? = nil
    
    // Encapsulates the data discretization for the model.
    private var dataHandler: AnalyticsDataHandler? = nil

    
#if !targetEnvironment(simulator)
    func getRecommendation() async throws -> [WidgetRecommendation] {
        
        var rawData = try AnalyticsController.getEntries()
        rawData = relevantData(from: rawData)
        
        if dataHandler == nil {
            dataHandler = AnalyticsDataHandler(
                data: rawData,
                locationGroupRadius: self.locationGroupRadius,
                timeNearbyThreshold: self.timeNearbyThreshold,
                dateNearbyThreshold: self.dateNearbyThreshold
            )
        }
                        
        if model == nil {
            model = try dataHandler?.getModel()
        }
    
        return try recommendationsFromModel().filter{ $0.priority > 0 }
    }
    
    private func recommendationsFromModel() throws -> [WidgetRecommendation] {
        
        guard let model else {
            throw RecommenderError.missingModel
        }
        
        guard let predictions = try? dataHandler?.getPredictions(model: model, parameters: modelParameters()) else {
            throw RecommenderError.impossiblePrediction
        }
                
        var result: [WidgetRecommendation] = []
        
        Widget.allCases.forEach { widget in
            let views = widget.associatedViews()
            
            var probability: Double = 0
            views.forEach { view in
                probability += predictions[view] ?? 0
            }
            
            result.append(WidgetRecommendation(widget: widget, priority: Int(probability * 100)))
        }
        
        print(result)
        return result
    }

    private func modelParameters() throws -> Dictionary<Covariate, String> {
        
        guard let dataHandler else {
            throw RecommenderError.missingData
        }
        
        let location = CLLocationManager().location ?? AppUsageData.invalidLocation
        let date = Date()
        
        return [
            Covariate.location: dataHandler.discreteValue(for: location),
            Covariate.time: dataHandler.discreteValue(for: date.time),
            Covariate.date: dataHandler.discreteValue(for: date)
        ]
    }
    
    // Some data entries should not affect our model, for example if the time spent on the
    // associated view is too short. Otherwise the initial app view would be represented in the
    // training data disproportionately often.
    private func relevantData(from data: [AppUsageDataEntity]) -> [AppUsageDataEntity] {
        return data.compactMap { entry in
            
            guard let startDate = entry.startTime, let endDate = entry.endTime else {
                return nil
            }
            
            // Time spent on the view should be more than 2 seconds.
            if abs(startDate.timeIntervalSince1970 - endDate.timeIntervalSince1970) <= 2 {
                return nil
            }
            
            return entry
        }
    }
        
#else
    func getRecommendation() async throws -> [WidgetRecommendation] {
        return []
    }
#endif
}
