//
//  SearchResultViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI
import CoreML
import NaturalLanguage

class SearchResultViewModel: ObservableObject {
    @Published var searchDataTypeResult = [String:Double]()
    @Published var orderedTypes = [SearchResultType]()
    @ObservedObject var model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    private lazy var dataTypeClassifier: NLModel? = {
        let model = try? NLModel(mlModel: DataTypeClassifierV2(configuration: MLModelConfiguration()).model)
        return model
    }()
    
    func prepare(_ query: String) -> String {
        let updatedQuery = query.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz 1234567890?"))
        
        return updatedQuery
    }
    
    func search(for query: String) async {
        let cleanedQuery = prepare(query)
        
        guard let modelOutput = dataTypeClassifier?.predictedLabelHypotheses(for: cleanedQuery, maximumCount: 5) else {
            return
        }
        for (label, accuracy) in modelOutput {
            print("\(label) was at \(accuracy)")
        }
        searchDataTypeResult = modelOutput
        
        orderedTypes = modelOutput.sorted(by: {$0.value > $1.value}).compactMap {SearchResultType(rawValue: $0.key)}
    }
    
}

enum SearchResultType: String {
    case Grade = "grade"
    case Calendar = "calendar"
    case News = "news"
    case Cafeteria = "cafeteria"
    case StudyRoom = "studyroom"
}
