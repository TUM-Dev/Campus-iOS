//
//  TUMOnlineAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation
import Alamofire
import XMLCoder
import UIKit

enum TUMOnlineAPI: API {
    // Different data types of data which determine the path, parameters and if authentication is needed.
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
    case averageGrades
    
    
    static let baseURL: String = "https://campus.tum.de/tumonline/"
    
    static let baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = TUMOnlineAPIError.self
    
    var paths: String {
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
        case .profileImage:         return "visitenkarte.showImage"
        case .averageGrades:         return "wbservicesbasic.absNoten"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .personSearch(search: let search):
            return ["pSuche": search]
        case .tokenRequest(tumID: let tumID, tokenName: let tokenName):
            let tokenName = tokenName ?? "TCA - \(UIDevice.current.name)"
            return ["pUsername" : tumID, "pTokenName" : tokenName]
        case .personDetails(identNumber: let identNumber):
            return ["pIdentNr": identNumber]
        case .lectureSearch(search: let search):
            return ["pSuche": search]
        case .lectureDetails(lvNr: let lvNr):
            return ["pLVNr": lvNr]
        case .profileImage(personGroup: let personGroup, id: let id):
            return ["pPersonenGruppe": personGroup, "pPersonenId": id]
        default:
            return [:]
        }
    }
    
    var needsAuth: Bool {
        switch self {
        case .personSearch(search: _),
            .tokenConfirmation,
            .tuitionStatus,
            .calendar,
            .personDetails(identNumber: _),
            .personalLectures,
            .personalGrades,
            .lectureSearch(search: _),
            .lectureDetails(_),
            .identify,
            .averageGrades: return true
        default:
            return false
        }
    }
    
    var dateDecodingStrategy: DateFormatter {
        switch self {
        case .calendar :
            return DateFormatter.yyyyMMddhhmmss
        default :
            return DateFormatter.yyyyMMdd
        }
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let xmlDecoder = XMLDecoder()
        xmlDecoder.dateDecodingStrategy = .formatted(self.dateDecodingStrategy)
        
        return try xmlDecoder.decode(type, from: data)
    }
    
    struct Response<T: Decodable>: Decodable {
        public var row: [T]
    }
    
    struct CalendarResponse: Decodable {
        // This is needed because for .calendar the response is not "rowset" and "row", instead it is "events" and "event"
        public var event: [CalendarEvent]
    }
    
    struct AverageGradesResponse: Decodable {
        public var studium: [AverageGrade]
    }
    
    static let imageCache = Cache<String, Data>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
}
