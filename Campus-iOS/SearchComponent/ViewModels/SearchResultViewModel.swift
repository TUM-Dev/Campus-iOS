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
    @Published var searchDataTypeResult = [(String, Double)]()
    @Published var orderedTypes = [SearchResultType]()
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    private lazy var dataTypeClassifierEnglish: NLModel? = {
        let model = try? NLModel(mlModel: DataTypeClassifierV4English(configuration: MLModelConfiguration()).model)
        return model
    }()
    
    private lazy var dataTypeClassifierGerman: NLModel? = {
        let model = try? NLModel(mlModel: DataTypeClassifierV4German(configuration: MLModelConfiguration()).model)
        return model
    }()
    
    func prepare(_ query: String) -> String {
        let updatedQuery = query.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz 1234567890?"))
        
        return updatedQuery
    }
    
    func search(for query: String) {
        let cleanedQuery = prepare(query)
        
        var language : String?
        if #available(iOS 16, *) {
            language = Locale.current.language.languageCode?.identifier
        } else {
            // Fallback on earlier versions
            language = Locale.current.languageCode
        }
        
        var modelOutput = [String:Double]()
        if let language = language, language == "de" {
            guard let modelOutputDE = dataTypeClassifierGerman?.predictedLabelHypotheses(for: cleanedQuery, maximumCount: 3) else {
                return
            }
            
            modelOutput = modelOutputDE
        } else {
            guard let modelOutputEN = dataTypeClassifierEnglish?.predictedLabelHypotheses(for: cleanedQuery, maximumCount: 3) else {
                return
            }
            
            modelOutput = modelOutputEN
        }
        
        if modelOutput.count == 0 {
            return
        }
        
        searchDataTypeResult = modelOutput.sorted(by: {$0.value > $1.value})
        
        orderedTypes = modelOutput.sorted(by: {$0.value > $1.value}).compactMap {SearchResultType(rawValue: $0.key)}
        
    }
}

enum SearchResultType: String {
    case Grade = "grade"
    case Calendar = "calendar"
    case News = "news"
    case Cafeteria = "cafeteria"
    case StudyRoom = "studyroom"
    case Movie = "movie"
}
