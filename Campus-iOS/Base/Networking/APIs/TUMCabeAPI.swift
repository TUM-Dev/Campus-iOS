//
//  TUMCabeAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation
import Alamofire
import UIKit

enum TUMCabeAPI: API {
    // Different data types of data which determine the path, parameters and if authentication is needed.
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
    
    static let baseURL = "https://app.tum.de/api/"
    static let baseHeaders: HTTPHeaders = ["X-DEVICE-ID": UIDevice.current.identifierForVendor?.uuidString ?? "not available",
                                                 "X-APP-VERSION": Bundle.main.version,
                                                 "X-APP-BUILD": Bundle.main.build,
                                                 "X-OS-VERSION": UIDevice.current.systemVersion,]
    static var error: APIError.Type = TUMCabeAPIError.self
    
    var paths: String {
        switch self {
        case .movie:                            return "kino"
        case .cafeteria:                        return "mensen"
        case .news(let source):                 return "news/\(source)/getAll"
        case .newsSources:                      return "news/sources"
        case .newsAlert:                        return "news/alert"
        case .roomSearch(let room):             return "roomfinder/room/search/\(room.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? "")"
        case .roomMaps(let room):               return "roomfinder/room/availableMaps/\(room.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? "")"
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
    
    var parameters: [String : String] {
        return [:]
    }
    
    var needsAuth: Bool {
        // No authentication needed
        return false
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddhhmmss)
        
        return try jsonDecoder.decode(type, from: data)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Self.baseURL.asURL()
        let urlRequest = try URLRequest(url: url.appendingPathComponent(paths), method: .get, headers: Self.baseHeaders)
        return urlRequest
    }
}
