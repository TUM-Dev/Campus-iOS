//
//  TUMCabeAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/4/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Alamofire

enum TUMCabeAPI: URLRequestConvertible {
    case movie
    case cafeteria
    case news(news: String)
    case roomSearch(query: String)
    case roomMaps(room: String)
    case mapImage(room: String, id: String)
    case registerDevice(publicKey: String)
    case eventy
    case myEvents
    case ticketTypes(event: Int)
    case ticketStats(event: Int)
    case ticketReservation
    case ticketReservationCancellation
    case ticketPurchase
    case stripeKey
    
    static let baseURLString = "https://app.tum.de/api"
    static let betaAppURLString = "https://beta.tumcampusapp.de"
    static let tumCabeHomepageURLString = "https://app.tum.de"
    static let tumCabeFingerprints = ["06 87 26 03 31 A7 24 03 D9 09 F1 05 E6 9B CF 0D 32 E1 BD 24 93 FF C6 D9 20 6D 11 BC D6 77 07 39"]
    static let baseHeaders: [String : String] = ["X-DEVICE-ID": UIDevice.current.identifierForVendor?.uuidString ?? "not available",
                                                 "X-APP-VERSION": Bundle.main.version,
                                                 "X-APP-BUILD": Bundle.main.build,
                                                 "X-OS-VERSION": UIDevice.current.systemVersion,]
    
    var path: String {
        switch self {
        case .movie:                        return "kino"
        case .cafeteria:                    return "mensen"
        case .news(let news):               return "news/\(news)"
        case .roomSearch(let query):        return "roomfinder/room/search/\(query)"
        case .roomMaps(let room):           return "roomfinder/room/availableMaps/\(room)"
        case .mapImage(let room, let id):   return "roomfinder/room/map/\(room)/\(id)"
        case .registerDevice(let publicKey):return "device/register/\(publicKey)"
        case .eventy:                       return "event/list"
        case .myEvents:                     return "event/ticket/my"
        case .ticketTypes(let event):       return "event/ticket/type/\(event)"
        case .ticketStats(let event):       return "event/ticket/status/\(event)"
        case .ticketReservation:            return "event/ticket/reserve"
        case .ticketReservationCancellation:return "event/ticket/reserve/cancel"
        case .ticketPurchase:               return "event/ticket/payment/stripe/purchase"
        case .stripeKey:                    return "event/ticket/payment/stripe/ephemeralkey"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    static var requiresAuth: [String] = []
    
    func asURLRequest() throws -> URLRequest {
        let url = try TUMCabeAPI.baseURLString.asURL()
        let urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method, headers: TUMCabeAPI.baseHeaders)
        return urlRequest
    }
}
