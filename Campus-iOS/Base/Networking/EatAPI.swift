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
            // Fetch new data and store in cache.
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
            } catch {
                print(error)
                throw error
            }
            
            
            
            // Requesting the queue data if there is an API for the cafeteria.
            var cafeterias = cafeteriasWithoutQueue
            
            for i in cafeterias.indices {
                var queueData: Data
                if let queue = cafeterias[i].queueStatusApi {
                    print("NAME " + cafeterias[i].name)
                    do {
                        queueData = try await AF.request(queue).serializingData().value
                    } catch {
                        print(error)
                        throw NetworkingError.deviceIsOffline
                    }
                    
                    do {
                        cafeterias[i].queue = try decoder.decode(Queue.self, from: queueData)
                    } catch {
                        throw error
                    }
                }
            }
            
            // Write value to cache
            cache.setValue(cafeterias, forKey: fullRequestURL, cost: cafeterias.count)
            return cafeterias
        }
    }
}
