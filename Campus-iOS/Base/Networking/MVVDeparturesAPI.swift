//
//  MVVDeparturesAPI.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Alamofire
import Foundation
import CoreLocation

struct MVVDeparturesAPI: URLRequestConvertible {
    
    static let baseURLStringPrefix = "https://efa.mvv-muenchen.de/ng/XML_DM_REQUEST?outputFormat=JSON&language=en&stateless=1&coordOutputFormat=WGS84&type_dm=stop&name_dm="
    static let baseURLStringSufix = "&useRealtime=1&itOptionsActive=1&ptOptionsActive=1&limit=20&mergeDep=1&useAllStops=1&mode=direct"
    
    let station: String
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try ("\(MVVDeparturesAPI.baseURLStringPrefix)\(station)\(MVVDeparturesAPI.baseURLStringSufix)").asURL()
        let urlRequest = try URLRequest(url: url, method: method)
        return urlRequest
    }
}
