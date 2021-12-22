//
//  TUMOnlineAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit.UIDevice
import Alamofire

enum TUMOnlineAPI: URLRequestConvertible {
    case personSearch(search: String)
    case tokenRequest(tumID: String, tokenName: String?)
    case tokenConfirmation
    case tuitionStatus
    case calendar
    case personDetails(identNumber: String)
    case personalLectures
    case personalGrades
    case lectureSearch(search: String)
    case lectureDetails(lvNr: String)
    case identify
    case secretUpload
    case profileImage(personGroup: String, id: String)
    
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
        case .secretUpload:         return "wbservicesbasic.secretUpload"
        case .profileImage:         return "visitenkarte.showImage?pPersonenGruppe=3&pPersonenId=9C4E2144041FAB5D"
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
        case let .personSearch(search):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pSuche": search])
        case let .tokenRequest(tumID, tokenName):
            let tokenName = tokenName ?? "TCA - \(UIDevice.current.name)"
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pUsername" : tumID, "pTokenName" : tokenName])
        case let .personDetails(identNumber):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pIdentNr": identNumber])
        case let .lectureSearch(search):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pSuche": search])
        case let .lectureDetails(lvNr):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pLVNr": lvNr])
        case let .profileImage(personGroup, id):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["pPersonenGruppe": personGroup, "pPersonenId": id])
        default:
            break
        }
        return urlRequest
    }
}
