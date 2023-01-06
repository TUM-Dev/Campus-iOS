//
//  TUMOnlineAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit.UIDevice
import Alamofire
import XMLCoder

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
    
    static let baseURLString = "https://campus.tum.de/tumonline/"
    
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
    
    var needsAuth: Bool {
        switch self {
        case
            .personSearch(search: _),
            .tokenConfirmation,
            .tuitionStatus,
            .calendar,
            .personDetails(identNumber: _),
            .personalLectures,
            .personalGrades,
            .lectureSearch(search: _),
            .lectureDetails(lvNr: _),
            .identify : return true
        case .tokenRequest(tumID: _, tokenName: _):
            return false
        case .secretUpload:
            return false
        case .profileImage(personGroup: _, id: _):
            return false
        }
    }

    
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
    
    var parameters: [String: String] {
        switch self {
        case let .personSearch(search):
            return ["pSuche": search]
        case let .tokenRequest(tumID, tokenName):
            let tokenName = tokenName ?? "TCA - \(UIDevice.current.name)"
            return["pUsername" : tumID, "pTokenName" : tokenName]
        case let .personDetails(identNumber):
            return["pIdentNr": identNumber]
        case let .lectureSearch(search):
            return["pSuche": search]
        case let .lectureDetails(lvNr):
            return ["pLVNr": lvNr]
        case let .profileImage(personGroup, id):
            return ["pPersonenGruppe": personGroup, "pPersonenId": id]
        default:
            return [:]
        }
    }
    
    var fullPathURL: String {
        Self.baseURLString + self.path
    }
    
    var fullRequestURL: String {
        self.fullPathURL + "?" + parameters.flatMap({ key, value in
            key + "=" + value
        })
    }
    
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
    
    static let decoder: XMLDecoder = {
        let decoder = XMLDecoder()
       
        decoder.dateDecodingStrategy = .formatted(.yyyyMMddhhmmss)
         
        return decoder
    }()
    
    static func makeRequest<T: Decodable>(endpoint: TUMOnlineAPI, token: String? = nil, forcedRefresh: Bool = false) async throws -> T {
        // Check cache first
        if !forcedRefresh,
           let data = Self.cache.value(forKey: endpoint.fullRequestURL),
           let typedData = data as? T {
            return typedData
        // Otherwise make the request
        } else {
            var data: Data
            do {
                data = try await asRequest(token: token).serializingData().value
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            // Check this first cause otherwise no error is thrown by the XMLDecoder
            if let error = try? Self.decoder.decode(CampusOnlineAPI.Error.self, from: data) {
                print(error)
                throw error
            }
            
            do {
                let decodedData = try Self.decoder.decode(T.self, from: data)
                
                // Write value to cache
                Self.cache.setValue(decodedData, forKey: endpoint.fullRequestURL, cost: data.count)
                
                return decodedData
            } catch {
                print(error)
                throw CampusOnlineAPI.Error.unknown(error.localizedDescription)
            }
        }
        
        func asRequest(token: String? = nil) -> DataRequest {
            if endpoint.needsAuth {
                return AF
                    .request(
                        endpoint.fullPathURL,
                        parameters: endpoint.parameters.merging(["pToken": token ?? ""], uniquingKeysWith: { (current, _) in current })
                    )
                    .cacheResponse(using: ResponseCacher(behavior: .cache))
            } else {
                return AF.request(endpoint.fullPathURL, parameters: endpoint.parameters)
            }
        }
    }
}
