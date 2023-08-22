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
    private var dataHandler: MLModelDataHandler? = nil
    
    // The model covariates (and the dependent variable).
    private enum Covariate: String {
        case location = "location", time = "time", date = "date", view = "view"
    }
    
#if !targetEnvironment(simulator)
    func getRecommendation() async throws -> [WidgetRecommendation] {
        
        var rawData = try AnalyticsController.getEntries()
        rawData = relevantData(from: rawData)
        
        if dataHandler == nil {
            dataHandler = MLModelDataHandler(
                data: rawData,
                locationGroupRadius: self.locationGroupRadius,
                timeNearbyThreshold: self.timeNearbyThreshold,
                dateNearbyThreshold: self.dateNearbyThreshold
            )
        }
        
        guard let dataTable = try? dataTable() else {
            throw RecommenderError.modelCreationFailed
        }
                        
        if model == nil {
            model = try createClassifier(from: dataTable).model
        }
    
        return try recommendationsFromModel(parameters: modelParameters()).filter{ $0.priority > 0 }
    }
    
    private func recommendationsFromModel(parameters: Dictionary<String, String>) throws -> [WidgetRecommendation] {
        
        guard let model else {
            throw RecommenderError.missingModel
        }
        
        guard let prediction = try? model.prediction(from: MLDictionaryFeatureProvider(dictionary: parameters)),
              let resultDict = prediction.featureValue(for: "\(Covariate.view.rawValue)Probability") else {
            throw RecommenderError.impossiblePrediction
        }
                
        var result: [WidgetRecommendation] = []
        try resultDict.dictionaryValue.forEach { view, probability in
            guard let view = CampusAppView(rawValue: view as? String ?? "") else {
                throw RecommenderError.badRecommendation
            }
            result.append(WidgetRecommendation(widget: view.associatedWidget(), priority: Int(probability.doubleValue * 100)))
        }
        
        print(result)
        return result
    }
    
    private func createClassifier(from data: MLDataTable) throws -> MLLogisticRegressionClassifier {
        
        let params = MLLogisticRegressionClassifier.ModelParameters(maxIterations: modelMaxIterations)
        
        guard let model = try? MLLogisticRegressionClassifier(trainingData: data, targetColumn: "view", parameters: params) else {
            throw RecommenderError.modelCreationFailed
        }
        
        return model
    }
    
    private func dataTable() throws -> MLDataTable {
        
        guard let data = try? dataHandler?.getData() else {
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
    
    private func evaluateModel(data: MLDataTable) throws {
        
        let (trainingData, testData) = data.randomSplit(by: 0.8)
        guard let classifier = try? createClassifier(from: trainingData) else {
            throw RecommenderError.modelCreationFailed
        }
        
        let metrics = classifier.evaluation(on: testData)
        let accuracy = (1 - metrics.classificationError) * 100
        print("🟣 Accuracy: \(accuracy) %")
    }

    private func modelParameters() throws -> Dictionary<String, String> {
        
        guard let dataHandler else {
            throw RecommenderError.missingData
        }
        
        let location = CLLocationManager().location ?? AppUsageData.invalidLocation
        let date = Date()
        
        return [
            Covariate.location.rawValue: dataHandler.discreteValue(for: location),
            Covariate.time.rawValue: dataHandler.discreteValue(for: date.time),
            Covariate.date.rawValue: dataHandler.discreteValue(for: date)
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
