//
//  API.swift
//  Campus-iOS
//
//  Created by David Lin on 10.02.23.
//

import Foundation
import Alamofire
import XMLCoder
import UIKit

protocol API {
    // The base URL will be the entry point for fetching the data.
    static var baseURL: String { get }
    // If the API requires headers, otherwise declare it as an empty array.
    static var baseHeaders: HTTPHeaders { get }
    // Type of error to handle errors properly for each API.
    static var error: APIError.Type { get }
    
    // This property should return the respective path for each data type
    var paths: String { get }
    // The different parameters used for each data type if they are needed, otherwise return an empty dict [:].
    var parameters: [String: String] { get }
    // Indicates which data types can only be fetched with authentication
    var needsAuth: Bool { get }
    
    // Returns the baseURL combinded with the relative paths. This is typically used in the asReqeust(token:) method.
    var basePathsURL: String { get }
    // Returns the basePathURL combined with all the parameters. This is typically used as an identifier for the cache.
    var basePathsParametersURL: String { get }
    
    
    /// Produces the final request depending considering if a data type needs authentication.
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
