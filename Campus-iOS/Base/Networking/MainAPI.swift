//
//  MainAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 16.01.23.
//

import Foundation
import Alamofire
import XMLCoder
import UIKit

protocol API {
    // The base URL which will be the entry point for fetching the data.
    static var baseURL: String { get }
    // If the API requires headers, otherwise declare as empty array.
    static var baseHeaders: HTTPHeaders { get }
    // Type of error to handle errors properly for each API.
    static var error : APIError.Type { get }
    
    // This property should return the respective path for each data type
    var paths: String { get }
    // The different parameters used for each data type if they are needed, otherwise return an empty dict [:].
    var parameters: [String: String] { get }
    // Indicates which data types can only be fetched with authentication
    var needsAuth: Bool { get }
    
    // Returns the baseURL combinded with the relative paths. This is typically used in the asReqeust(token:) method.
    var basePathsURL: String { get }
    // Returns the basePathURL combined with all the parameters. This is typically used as identifier for the cache.
    var basePathsParametersURL: String { get }
    
    
    /// Produces the final request depending concidering if a data type needs authentication.
    ///
    /// ```
    /// let api = CampusOnline.personalLectures
    /// let token = "1234"
    /// let request = api.asRequest(token) // A data request used to fetch the data
    ///
    /// do {
    ///     let data = try await request.serializingData.value
    /// } catch {
    ///     print("Error occured fetching data: \(String(describing: error))")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///     - token: The token used to authenticate.
    /// - Returns: An `Alamofire.DataRequest` depending on the `token`.
    func asRequest(token: String?) -> DataRequest
    
    /// Uses a decoder (either JSON or XML depending on the API) to decode the fetched data.
    ///
    /// ```
    /// let data = ...
    /// let api = CampusOnline.personalGrades
    /// do {
    ///     let decodedData = try api.decode(type: Grades.self, from: data)
    /// } catch {
    ///     print("Error occurred while decoding: \(String(describing: error))")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///     - type: Generic data type, which conforms to `Decodable`.
    ///     - data: The data to be decoded into `type`.
    /// - Throws: Throws decoding error if decoding failed.
    /// - Returns: The data in the decoded data format.
    func decode<T:Decodable>(_ type: T.Type, from data: Data) throws -> T
}

enum MainAPI {
    // Maximum size of cache: 500kB, Maximum cache entries: 1000, Lifetime: 10min
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
    
    /// Returns a generic value of type `T` fetched from the API or the cache.
    ///
    /// ```
    /// print(hello("world")) // "Hello, world!"
    /// ```
    /// This method uses the specified `endpoint` to make a request, i.e. fetch the data, decode it and to check if any given error occured.
    /// If the cache is stil valid (lifetime not expired yet) and the `forcedRefresh` is `false` then data is not fetched from the `endpoint`.
    /// Instead the data is retrieved from the cache.
    ///
    /// > Warning: Some APIs need a token for authentication purposes.
    ///
    /// - Parameters:
    ///     - endpoint: An value conforming to the `API`protocol.
    ///     - token: A string representing the authentication token
    ///     - forcedRefresh
    /// - Throws: Depending on the error, either the a networking or decoding error occurred.
    /// - Returns: The retrieved data in as of generic type `T`.
    static func makeRequest<T: Decodable, S: API>(endpoint: S, token: String? = nil, forcedRefresh: Bool = false) async throws -> T {
        // Check cache first
        if !forcedRefresh, let data = cache.value(forKey: endpoint.basePathsParametersURL), let typedData = data as? T {
            return typedData
        // Otherwise make the request
        } else {
            var data: Data
            do {
                data = try await endpoint.asRequest(token: token).serializingData().value
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            do {
                // Decode data from the respective endpoint.
                let decodedData = try endpoint.decode(T.self, from: data)
                // Write value to cache
                cache.setValue(decodedData, forKey: endpoint.basePathsParametersURL, cost: data.count)
                
                return decodedData
                
            } catch {
                // Try to decode the error occured by decoding, if the error can't be decoded then we throw the "raw" error from the decoder.
                if let decodingError = try? endpoint.decode(S.error, from: data) {
                    print(decodingError)
                    throw decodingError
                } else {
                    print(error)
                    throw error
                }
            }
        }
    }
}

enum CampusOnline: API {
    // Different data types of data which determine the path, parameters and if authentication is needed.
    case personalLectures
    case personalGrades
    case lectureDetails(lvNr: String)
    
    static let baseURL: String = "https://campus.tum.de/tumonline/"
    
    static let baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = CampusOnlineAPIError.self
    
    var paths: String {
        switch self {
            case .personalLectures: return "wbservicesbasic.veranstaltungenEigene"
            case .personalGrades: return "wbservicesbasic.noten"
            case .lectureDetails: return "wbservicesbasic.veranstaltungenDetails"
        }
    }
    
    var parameters: [String : String] {
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
    
    var basePathsURL: String {
        Self.baseURL + self.paths
    }
    
    var basePathsParametersURL: String {
        basePathsURL + "?" + parameters.flatMap({ key, value in
            key + "=" + value
        })
    }
    
    
    func asRequest(token: String?) -> Alamofire.DataRequest {
        let finalParameters = self.needsAuth ? self.parameters.merging(["pToken": token ?? ""], uniquingKeysWith: { (current, _) in current }) : self.parameters
        
        return AF.request(self.basePathsURL, parameters: finalParameters, headers: Self.baseHeaders).cacheResponse(using: ResponseCacher(behavior: .cache))
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let xmlDecoder = XMLDecoder()
        xmlDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        return try xmlDecoder.decode(type, from: data)
    }
}

enum TUMCabeAPI2: API {
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
    
    var parameters: [String : String] {
        return [:]
    }
    
    var needsAuth: Bool {
        // No authentication needed
        return false
    }
    
    
    var basePathsURL: String {
        return Self.baseURL + self.paths
    }
    
    var basePathsParametersURL: String {
        return self.basePathsURL
    }
    
    
    func asRequest(token: String? = nil) -> Alamofire.DataRequest {
        // Since no authentication is required we do not use the token.
        return AF.request(self.basePathsURL, headers: Self.baseHeaders)
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddhhmmss)
        
        return try jsonDecoder.decode(type, from: data)
    }
}
