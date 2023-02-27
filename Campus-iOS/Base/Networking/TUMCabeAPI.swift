//
//  TUMCabeAPI.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/4/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Alamofire
import UIKit

enum TUMCabeAPI: URLRequestConvertible {
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
    
    static let baseURLString = "https://app.tum.de/api"
    static let serverTrustPolicies: [String: ServerTrustEvaluating] = ["app.tum.de" : PinnedCertificatesTrustEvaluator()]
    static let baseHeaders: HTTPHeaders = ["X-DEVICE-ID": UIDevice.current.identifierForVendor?.uuidString ?? "not available",
                                                 "X-APP-VERSION": Bundle.main.version,
                                                 "X-APP-BUILD": Bundle.main.build,
                                                 "X-OS-VERSION": UIDevice.current.systemVersion,]
    
    var path: String {
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
    
    var fullPathURL: String {
        Self.baseURLString + "/" + self.path
    }
    
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
       
        decoder.dateDecodingStrategy = .formatted(.yyyyMMddhhmmss)
         
        return decoder
    }()
    
    static func makeRequest<T: Decodable>(endpoint: TUMCabeAPI, forcedRefresh: Bool = false) async throws -> T {
        // Check cache first
        if !forcedRefresh,
           let data = Self.cache.value(forKey: endpoint.fullPathURL),
           let typedData = data as? T {
            return typedData
        // Otherwise make the request
        } else {
            var data: Data
            do {
                data = try await asRequest().serializingData().value
//                if T.self is FoundRoom.Type {
//                    print(String(data: data, encoding: .utf8))
//                }
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            if let error = try? Self.decoder.decode(TUMCabeAPIError.self, from: data) {
                print(error)
                throw error
            }
            
            do {
                let decodedData = try Self.decoder.decode(T.self, from: data)
                
                // Write value to cache
                Self.cache.setValue(decodedData, forKey: endpoint.fullPathURL, cost: data.count)
                
                return decodedData
            } catch {
                print(error)
                throw TUMCabeAPIError.unkown(error.localizedDescription)
            }
        }
        
        func asRequest() -> DataRequest {
            return AF.request(endpoint.fullPathURL, method: .get, headers: baseHeaders)
        }
    }
}
