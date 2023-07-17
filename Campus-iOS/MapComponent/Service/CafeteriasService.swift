//
//  CafeteriasServiceProtocol.swift
//  Campus-iOS
//
//  Created by David Lin on 14.05.22.
//

import Foundation
import Alamofire

protocol CafeteriasServiceProtocol {
    func fetch(forcedRefresh: Bool) async throws -> [Cafeteria]
}

struct CafeteriasService: ServiceProtocol, CafeteriasServiceProtocol {
    typealias T = Cafeteria
    
    func fetch(forcedRefresh: Bool) async throws -> [Cafeteria] {
        let endpoint = EatAPI.canteens
        
        var response: [Cafeteria] = try await MainAPI.makeRequest(endpoint: endpoint)
        
        for i in response.indices {
            if let queueStatusApi = response[i].queueStatusApi {
                response[i].queue = try await fetch(eatAPI: endpoint, queueStatusApi: queueStatusApi, forcedRefresh: forcedRefresh)
            }
        }
        
        return response
    }
    
    func fetch(eatAPI: EatAPI, queueStatusApi: String, forcedRefresh: Bool) async throws -> Queue {
        if !forcedRefresh, let data = MainAPI.cache.value(forKey: queueStatusApi), let typedData = data as? Queue {
            return typedData
        } else {
            var data: Data
            do {
                data = try await AF.request(queueStatusApi).serializingData().value
            } catch {
                print(error)
                throw NetworkingError.deviceIsOffline
            }
            
            if let error = try? eatAPI.decode(EatAPI.error, from: data) {
                print(error)
                throw error
            }
            
            do {
                // Decode data from the respective endpoint.
                let decodedData = try eatAPI.decode(Queue.self, from: data)
                // Write value to cache
                MainAPI.cache.setValue(decodedData, forKey: queueStatusApi, cost: data.count)
                
                return decodedData
                
            } catch {
                print(error)
                throw EatAPI.error.init(message: error.localizedDescription)
            }
        }
    }
}
