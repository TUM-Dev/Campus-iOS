//
//  MainAPI.swift
//  Campus-iOS
//
//  Created by David Lin on 16.01.23.
//

import Foundation
import Alamofire
import XMLCoder


enum MainAPI {
    // Maximum size of cache: 500kB, Maximum cache entries: 1000, Lifetime: 10min
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 10 * 60)
    
    /// Returns a generic value of type `T` fetched from the API or the cache.
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
