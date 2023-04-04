//
//  NavigaTumAPI.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//
import Foundation

struct NavigaTumAPI: NetworkingAPI {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        return decoder
    }()

    // Maximum size of cache: 500kB, Maximum cache entries: 1000, Lifetime: 60min
    static let cache = Cache<String, Decodable>(totalCostLimit: 500_000, countLimit: 1_000, entryLifetime: 60 * 60)

    static func makeRequest<T: Decodable>(endpoint: APIConstants, token: String? = nil, forcedRefresh: Bool? = nil) async throws -> T {
        // Check cache first
        if let data = cache.value(forKey: endpoint.fullRequestURL),
           let typedData = data as? T {
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
                let decodedData = try Self.decoder.decode(T.self, from: data)

                // Write value to cache
                cache.setValue(decodedData, forKey: endpoint.fullRequestURL, cost: data.count)

                return decodedData
            } catch {
                print(error)
                throw NetworkingError.decodingFailed(error)
            }
        }
    }
}
