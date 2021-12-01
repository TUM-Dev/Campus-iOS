//
//  EatAPI.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Alamofire
import Foundation

enum EatAPI: URLRequestConvertible {
    case canteens
    case all
    case all_ref
    case menu(location: String, year: Int = Date().year, week: Int = Date().weekOfYear)


    static let baseURLString = "https://tum-dev.github.io/eat-api/"

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .canteens:                         return "canteens.json"
        case .all:                              return "all.json"
        case .all_ref:                          return "all_ref.json"
        case let .menu(location, year, week):   return "\(location)/\(year)/\(week).json"
        }
    }

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let url = try EatAPI.baseURLString.asURL()
        let urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        return urlRequest
    }
}

