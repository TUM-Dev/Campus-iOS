////
////  APIs.swift
////  TUM Campus App
////
////  Created by Tim Gymnich on 12/30/18.
////  Copyright © 2018 TUM. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//struct Constants {
//    let tumCabeFingerprints = ["06 87 26 03 31 A7 24 03 D9 09 F1 05 E6 9B CF 0D 32 E1 BD 24 93 FF C6 D9 20 6D 11 BC D6 77 07 39"]
//    let mvgKey = "5af1beca494712ed38d313714d4caff6"
//}
//
//
//
///// API Body
//protocol API {
//    /// Endpoint Reference
//    associatedtype Endpoint: APIEndpoint
//    /// Base URL for the api
//    static var baseURL: String { get }
//    /// Headers that should be included into every single request
//    static var baseHeaders: [String:String] { get }
//    /// Queries that should be included into every single request
//    static var baseQueries: [String:String] { get }
//}
//
//extension API {
//    /// URL Object for the API
//    static var base: URL! {
//        return URL(string: Self.baseURL)
//    }
//
//    /// Default is empty
//    static var baseHeaders: [String:String] {
//        return [:]
//    }
//
//    /// Default is empty
//    static var baseQueries: [String:String] {
//        return [:]
//    }
//}
//
//protocol APIEndpoint {
//    /// Raw value string for the key
//    var rawValue: String { get }
//}
//
//
//enum MVGAPIEndpoint: String, APIEndpoint {
//    case getNearbyStations = "fahrinfo/api/location/nearby"
//    case departure = "fahrinfo/api/departure/{id}"
//}
//
//struct MVGAPI: API {
//    typealias Endpoint = MVGAPIEndpoint
//
//    static let baseURL = "https://www.mvg.de"
//    static let apiKey = "5af1beca494712ed38d313714d4caff6"
//    static let baseHeaders = ["X-MVG-Authorization-Key": apiKey, "User-Agent": Bundle.main.userAgent]
//
//}
//
//struct TUMSexyEndpoint: APIEndpoint {
//    static let sexy = TUMSexyEndpoint()
//    var rawValue: String {  // ???
//        return ""
//    }
//
//}
//
//struct TUMSexyAPI: API {
//    typealias Endpoint = TUMSexyEndpoint
//
//    static let baseURL = "https://json.tum.sexy"
//    static let baseHeaders = ["User-Agent": Bundle.main.userAgent]
//
//}
//
//enum TUMOnlineEndpoint: String, APIEndpoint {
//    case personSearch = "wbservicesbasic.personenSuche"
//    case tokenRequest = "wbservicesbasic.requestToken"
//    case tokenConfirmation = "wbservicesbasic.isTokenConfirmed"
//    case tuitionStatus = "wbservicesbasic.studienbeitragsstatus"
//    case calendar = "wbservicesbasic.kalender"
//    case personDetails = "wbservicesbasic.personenDetails"
//    case personalLectures = "wbservicesbasic.veranstaltungenEigene"
//    case personalGrades = "wbservicesbasic.noten"
//    case lectureSearch = "wbservicesbasic.veranstaltungenSuche"
//    case lectureDetails = "wbservicesbasic.veranstaltungenDetails"
//    case identify = "wbservicesbasic.id"
//}
//
//struct TUMOnlineAPI2: API {
//    typealias Endpoint = TUMOnlineEndpoint
//
//    static let baseURL = "https://campus.tum.de/tumonline"
//    static var user: User?
//
////    static var baseQueries: [String : String] {
////        guard let token = user?.token else {
////            return [:]
////        }
////        return [
////            "pToken": token,
////        ]
////    }
//
//    static let baseHeaders = ["User-Agent": Bundle.main.userAgent]
//}
//
//enum StudyRoomEndpoint: String, APIEndpoint {
//    case rooms = "ris_api.php"
//}
//
//struct StudyRoomAPI: API {
//    typealias Endpoint = StudyRoomEndpoint
//
//    static let baseURL = "http://www.devapp.it.tum.de/iris/"
//    static let baseQueries = ["format": "json"]
//    static let baseHeaders = ["User-Agent": Bundle.main.userAgent]
//
//}
//
//
//enum MensaAppEndpoint: String, APIEndpoint {
//    case exported = "exportDB.php"
//}
//
//struct MensaAppAPI: API {
//    typealias Endpoint = MensaAppEndpoint
//
//    static let baseURL = "http://lu32kap.typo3.lrz.de/mensaapp"
//    static let baseHeaders = ["User-Agent": Bundle.main.userAgent]
//
//}
//
//enum TUMCabeEndpoint: String, APIEndpoint {
//    case movie = "kino/"
//    case cafeteria = "mensen/"
//    case news = "news/{news}"
//    case searchRooms = "roomfinder/room/search/{query}"
//    case roomMaps = "roomfinder/room/availableMaps/{room}"
//    case mapImage = "roomfinder/room/map/{room}/{id}"
//}
//
//class TUMCabeAPI2: API {
//    typealias Endpoint = TUMCabeEndpoint
//
//    static let baseURL = "https://app.tum.de/api/"
//    static let betaAppURL = "https://beta.tumcampusapp.de"
//    static let tumCabeHomepageURL = "https://app.tum.de/"
//    static let tumCabeFingerprints = ["06 87 26 03 31 A7 24 03 D9 09 F1 05 E6 9B CF 0D 32 E1 BD 24 93 FF C6 D9 20 6D 11 BC D6 77 07 39"]
//
//    static var baseHeaders: [String : String] {
//        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return [:] }
//        return [
//            "X-DEVICE-ID": uuid,
//            "X-APP-VERSION": Bundle.main.version,
//            "X-APP-BUILD": Bundle.main.build,
//            "X-OS-VERSION": UIDevice.current.systemVersion,
//            "User-Agent": Bundle.main.userAgent,
//        ]
//    }
//
//}
