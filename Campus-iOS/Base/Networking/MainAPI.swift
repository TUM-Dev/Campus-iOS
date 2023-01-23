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

extension API {
    var basePathsURL: String {
        Self.baseURL + self.paths
    }
    
    var basePathsParametersURL: String {
        if parameters.isEmpty {
            return basePathsURL
        } else {
            return basePathsURL + "?" + parameters.flatMap({ key, value in
                key + "=" + value
            })
        }
    }
    
    func asRequest(token: String?) -> Alamofire.DataRequest {
        let finalParameters = self.needsAuth ? self.parameters.merging(["pToken": token ?? ""], uniquingKeysWith: { (current, _) in current }) : self.parameters
        
        return AF.request(self.basePathsURL, parameters: finalParameters, headers: Self.baseHeaders).cacheResponse(using: ResponseCacher(behavior: .cache))
    }
}

enum APIState<T: Decodable> {
    case na
    case loading
    case success(data: T)
    case failed(error: Error)
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
                if T.self is TUMOnlineAPI2.Response<Profile>.Type {
//                    print("\(String(data: data, encoding: .utf8))")
                }
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            if let error = try? endpoint.decode(S.error, from: data) {
                print(error)
                throw error
            }
            
            do {
                // Decode data from the respective endpoint.
                let decodedData = try endpoint.decode(T.self, from: data)
                // Write value to cache
                cache.setValue(decodedData, forKey: endpoint.basePathsParametersURL, cost: data.count)
                
                return decodedData
                
            } catch {
                print(error)
                throw S.error.init(message: error.localizedDescription)
            }
        }
    }
}

enum TUMOnlineAPI2: API {
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
                .identify: return true
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
    
    static let imageCache = Cache<String, Data>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
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

enum EatAPI2: API {
    case canteens
    case languages
    case labels
    case all
    case all_ref
    case menu(location: String, year: Int = Date().year, week: Int = Date().weekOfYear)
    
    static var baseURL: String = "https://tum-dev.github.io/eat-api/"
    
    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = EatAPIError.self
    
    var paths: String {
        switch self {
            case .canteens:                         return "enums/canteens.json"
            case .languages:                        return "enums/languages.json"
            case .labels:                           return "enums/labels.json"
            case .all:                              return "all.json"
            case .all_ref:                          return "all_ref.json"
            case let .menu(location, year, week):   return "\(location)/\(year)/\(String(format: "%02d", week)).json"
        }
    }
    
    var parameters: [String : String] { [:] }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        return try jsonDecoder.decode(type, from: data)
    }
}

enum TUMDevAppAPI2: API {
    case room(roomNr: Int)
    case rooms
    
    static var baseURL: String = "https://www.devapp.it.tum.de/"
    
    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = TUMDevAppAPIError.self
    
    var paths: String {
        switch self {
        case .room, .rooms:             return "iris/ris_api.php"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .room(roomNr: let roomNr):
            return ["format": "json", "raum": String(roomNr)]
        case .rooms:
            return ["format": "json"]
        }
    }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
    
    
}

enum TUMSexyAPI2: API {
    static var baseURL: String = "https://json.tum.sexy/"
    
    static var baseHeaders: Alamofire.HTTPHeaders = []
    
    static var error: APIError.Type = TUMSexyAPIError.self
    
    var paths: String { "" }
    
    var parameters: [String : String] { [:] }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}

enum MVGAPI2: API {
    case nearby(latitude: String, longitude: String)
    case departure(id: Int)
    case station(name: String)
    case id(id: Int)
    case interruptions
    
    static var baseURL: String = "https://www.mvg.de/"
    
    static let apiKey = "5af1beca494712ed38d313714d4caff6"
    static var baseHeaders: Alamofire.HTTPHeaders = ["X-MVG-Authorization-Key": apiKey]
    
    static var error: APIError.Type = MVGAPIError.self
    
    var paths: String {
        switch self {
        case .nearby:               return "fahrinfo/api/location/nearby"
        case .departure(let id):    return "fahrinfo/api/departure/\(id)"
        case .station:              return "fahrinfo/api/location/queryWeb"
        case .id:                   return "fahrinfo/api/location/query"
        case .interruptions:        return ".rest/betriebsaenderungen/api/interruption"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .station(name: let name):
            return ["q": name]
        case .id(id: let id):
            return ["q": String(id)]
        case .departure(id: _):
            return ["footway": String(0)]
        case .nearby(latitude: let latitude, longitude: let longitude):
            return ["latitude": latitude, "longitude": longitude]
        default:
            return [:]
        }
    }
    
    var needsAuth: Bool { false }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
