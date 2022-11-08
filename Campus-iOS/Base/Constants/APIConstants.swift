//
//  APIConstants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation
import Alamofire
import UIKit

protocol APIConstants {
    static var baseURL: String { get }
    var relativePathURL: String { get }
    var fullPathURL: String { get }
}

protocol CampusOnlineProtocol: APIConstants {
    var parameters: [String: String] { get }
    var needsAuth: Bool { get }
    
    func asRequest(_ token: String?) -> DataRequest
}

protocol TUMCabeProtocol: APIConstants {
    static var baseHeaders: HTTPHeaders { get }
    
    func asRequest() -> DataRequest
}

extension Constants {
    enum API {
        enum CampusOnline: CampusOnlineProtocol {
            static let baseURL = "https://campus.tum.de/tumonline/"
            
            case personalLectures
            case personalGrades
            case lectureDetails(lvNr: String)
            
            var relativePathURL: String {
                switch self {
                case .personalLectures: return "wbservicesbasic.veranstaltungenEigene"
                case .personalGrades: return "wbservicesbasic.noten"
                case .lectureDetails: return "wbservicesbasic.veranstaltungenDetails"
                }
            }
            
            var fullPathURL: String {
                Self.baseURL + self.relativePathURL
            }
            
            var parameters: [String: String] {
                switch self {
                case .personalLectures, .personalGrades: return [:]
                case .lectureDetails(let lvNr): return ["pLVNr": lvNr]
                }
            }
            
            var needsAuth: Bool {
                switch self {
                    case .personalLectures, .personalGrades, .lectureDetails(_): return true
                }
            }
            
            func asRequest(_ token: String? = nil) -> Alamofire.DataRequest {
                if self.needsAuth {
                    return AF
                        .request(
                            self.fullPathURL,
                            parameters: self.parameters.merging(["pToken": token ?? ""], uniquingKeysWith: { (current, _) in current })
                        )
                        .cacheResponse(using: ResponseCacher(behavior: .cache))
                } else {
                    return AF.request(self.fullPathURL, parameters: self.parameters)
                }
            }
        }
        
        enum TUMCabe: TUMCabeProtocol {
            static var baseURL: String = "https://app.tum.de/api/"
//            static let serverTrustPolicies: [String: ServerTrustEvaluating] = ["app.tum.de" : PinnedCertificatesTrustEvaluator()]
            static let baseHeaders: HTTPHeaders = [
                "X-DEVICE-ID": UIDevice.current.identifierForVendor?.uuidString ?? "not available",
                "X-APP-VERSION": Bundle.main.version,
                "X-APP-BUILD": Bundle.main.build,
                "X-OS-VERSION": UIDevice.current.systemVersion
            ]
            
            case movie
            case cafeteria
            case news(source: String)
            case newsSources
            case newsAlert
            case roomSearch(query: String)
            case roomMaps(room: String)
            case roomCoordinates(room: String)
            case mapImage(room: String, id: Int)
            case defaultMap(room: String)
            case registerDevice(publicKey: String)
            case events
            case myEvents
            case ticketTypes(event: Int)
            case ticketStats(event: Int)
            case ticketReservation
            case ticketReservationCancellation
            case ticketPurchase
            case stripeKey
            
            var relativePathURL: String {
                switch self {
                case .movie:                            return "kino"
                case .cafeteria:                        return "mensen"
                case .news(let source):                             return "news/\(source)/getAll"
                case .newsSources:                      return "news/sources"
                case .newsAlert:                        return "news/alert"
                case .roomSearch(let room):             return "roomfinder/room/search/\(room.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? "")"
                case .roomMaps(let room):               return "roomfinder/room/availableMaps/\(room)"
                case .roomCoordinates(let room):        return "roomfinder/room/coordinates/\(room)"
                case .defaultMap(let room):             return "roomfinder/room/defaultMap/\(room)"
                case .mapImage(let room, let id):       return "roomfinder/room/map/\(room)/\(id)"
                case .registerDevice(let publicKey):    return "device/register/\(publicKey)"
                case .events:                           return "event/list"
                case .myEvents:                         return "event/ticket/my"
                case .ticketTypes(let event):           return "event/ticket/type/\(event)"
                case .ticketStats(let event):           return "event/ticket/status/\(event)"
                case .ticketReservation:                return "event/ticket/reserve"
                case .ticketReservationCancellation:    return "event/ticket/reserve/cancel"
                case .ticketPurchase:                   return "event/ticket/payment/stripe/purchase"
                case .stripeKey:                        return "event/ticket/payment/stripe/ephemeralkey"
                }
            }
            
            var fullPathURL: String {
                Self.baseURL + self.relativePathURL
            }
            
            func asRequest() -> Alamofire.DataRequest {
                return AF.request(fullPathURL, headers: Self.baseHeaders)
            }
        }
    }
}
