//
//  EatAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation
import Alamofire

enum EatAPI: API {
    case canteens
    case languages
    case labels
    case all
    case all_ref
    case menu(location: String, year: Int = Date().year, week: Int = Date().weekOfYear)
    
    static var baseURL: String = "https://tum-dev.github.io/eat-api/"
    
    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = EatAPIError.self
    
    var paths: String {
        switch self {
            case .canteens:                         return "enums/canteens.json"
            case .languages:                        return "enums/languages.json"
            case .labels:                           return "enums/labels.json"
            case .all:                              return "all.json"
            case .all_ref:                          return "all_ref.json"
            case let .menu(location, year, week):   return "\(location)/\(year)/\(String(format: "%02d", week)).json"
        }
    }
    
    var parameters: [String : String] { [:] }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        return try jsonDecoder.decode(type, from: data)
    }
}
