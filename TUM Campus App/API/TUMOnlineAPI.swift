//
//  TUMOnlineAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Alamofire

enum TUMOnlineAPI: URLRequestConvertible {
    case personSearch(token: String, search: String)
    case tokenRequest(tumID: String, tokenName: String?)
    case tokenConfirmation(token: String)
    case tuitionStatus(token: String)
    case calendar(token: String)
    case personDetails(token: String, identNumber: String)
    case personalLectures(token: String)
    case personalGrades(token: String)
    case lectureSearch(token: String, search: String)
    case lectureDetails(token: String, lvNr: String)
    case identify(token: String)
    
    static let baseURLString = "https://campus.tum.de/tumonline"
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .personSearch:         return "wbservicesbasic.personenSuche"
        case .tokenRequest:         return "wbservicesbasic.requestToken"
        case .tokenConfirmation:    return "wbservicesbasic.isTokenConfirmed"
        case .tuitionStatus:        return "wbservicesbasic.studienbeitragsstatus"
        case .calendar:             return "wbservicesbasic.kalender"
        case .personDetails:        return "wbservicesbasic.personenDetails"
        case .personalLectures:     return "wbservicesbasic.veranstaltungenEigene"
        case .personalGrades:       return "wbservicesbasic.noten"
        case .lectureSearch:        return "wbservicesbasic.veranstaltungenSuche"
        case .lectureDetails:       return "wbservicesbasic.veranstaltungenDetails"
        case .identify:             return "wbservicesbasic.id"
        }
    }
    
    static var requiresAuth: [String] = [
        "wbservicesbasic.personenSuche",
        "wbservicesbasic.isTokenConfirmed",
        "wbservicesbasic.studienbeitragsstatus",
        "wbservicesbasic.kalender",
        "wbservicesbasic.personenDetails",
        "wbservicesbasic.veranstaltungenEigene",
        "wbservicesbasic.noten",
        "wbservicesbasic.veranstaltungenSuche",
        "wbservicesbasic.veranstaltungenDetails",
        "wbservicesbasic.id",
        ]

    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try TUMOnlineAPI.baseURLString.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
        case let .personSearch(token, search):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token, "pSuche": search])
        case let .tokenRequest(tumID, tokenName):
            let tokenName = tokenName ?? "TCA - \(UIDevice.current.name)"
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pUsername" : tumID, "pTokenName" : tokenName])
        case let .tokenConfirmation(token):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token])
        case let .tuitionStatus(token):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token])
        case let .calendar(token):
            return urlRequest
            /*urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token])*/
        case let .personDetails(token, identNumber):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token, "pIdentNr": identNumber])
        case let .personalLectures(token):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token])
        case let .personalGrades(token):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token])
        case let .lectureSearch(token, search):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token, "pSuche": search])
        case let .lectureDetails(token, lvNr):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token, "pLVNr": lvNr])
        case let .identify(token):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": token])
        }
        
        return urlRequest
    }
}
