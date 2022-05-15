//
//  EatAPI.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 22.12.21.
//

import Alamofire
import Foundation
import CoreLocation

enum EatAPI: URLRequestConvertible {
    case canteens
    case languages
    case labels
    case all
    case all_ref
    case menu(location: String, year: Int = Date().year, week: Int = Date().weekOfYear)
    
    static let baseURLString = "https://tum-dev.github.io/eat-api/"

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
            case .canteens:                         return "enums/canteens.json"
            case .languages:                        return "enums/languages.json"
            case .labels:                           return "enums/labels.json"
            case .all:                              return "all.json"
            case .all_ref:                          return "all_ref.json"
            case let .menu(location, year, week):   return "\(location)/\(year)/\(String(format: "%02d", week)).json"
        }
    }

    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try EatAPI.baseURLString.asURL()
        let urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        return urlRequest
    }
    
    static let decoder = JSONDecoder()
    
    // Maximum size of cache: 500kB, Maximum cache entries: 1000, Lifetime: 10min
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
    
    static func fetchCafeterias(forcedRefresh: Bool) async throws -> [Cafeteria] {
        

        let fullRequestURL = baseURLString + self.canteens.path
        
        if !forcedRefresh, let rawCafeterias = cache.value(forKey: baseURLString + self.canteens.path), let cafeterias = rawCafeterias as? [Cafeteria] {
            print("Canteen data from cache")
            return cafeterias
        } else {
            print("Canteen data from server")

//            let sessionManager = Session.defaultSession
//            let locationManager = CLLocationManager()

            // fetch new data and store in cache.
            var cafeteriaData: Data
            do {
                cafeteriaData = try await AF.request(self.canteens).serializingData().value
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            var cafeteriasWithoutQueue = [Cafeteria]()
            do {
                cafeteriasWithoutQueue = try decoder.decode([Cafeteria].self, from: cafeteriaData)
                return cafeteriasWithoutQueue
            } catch {
                print(error)
                throw error
            }
            
            /*
            let cafeterias = cafeteriasWithoutQueue
            
            
            for var cafeteria in cafeteriasWithoutQueue {
                var queueData: Data
                if let queue = cafeteria.queueStatusApi {
                    do {
                        queueData = try await AF.request(queue).serializingData().value
                    } catch {
                        print(error)
                        throw NetworkingError.deviceIsOffline
                    }
                    
                    do {
                        cafeteria.queue = try decoder.decode(Queue.self, from: queueData)
                    } catch {
                        throw error
                    }
                }
            }
            
            // Write value to cache
            cache.setValue(cafeterias, forKey: fullRequestURL, cost: cafeterias.count)
            return cafeterias
            */
                
            
            
//            sessionManager.request(self.canteens).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [self] response in
//                cafeterias = response.value ?? []
//                if let currentLocation = locationManager.location {
//                    cafeterias.sortByDistance(to: currentLocation)
//                }
//
//                for (index, cafeteria) in cafeterias.enumerated() {
//                    if let queue = cafeteria.queueStatusApi  {
//                        sessionManager.request(queue, method: .get).responseDecodable(of: Queue.self, decoder: JSONDecoder()){ response in
//                            cafeterias[index].queue = response.value
//                        }
//                    }
//                }
//
//                // Write canteens to cache
//                cache.setValue(cafeterias, forKey: baseURLString + self.canteens.path, cost: cafeterias.count)
//            }
//
//            return cafeterias
        }
    }
}
