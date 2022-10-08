//
//  RecommenderError.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 28.09.22.
//

import Foundation

enum RecommenderError: Error {
    case missingData, missingModel, modelCreationFailed, impossiblePrediction, badRecommendation
}
