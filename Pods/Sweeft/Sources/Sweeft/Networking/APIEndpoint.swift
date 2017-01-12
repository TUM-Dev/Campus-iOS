//
//  APIDescription.swift
//  Pods
//
//  Created by Mathias Quintero on 12/21/16.
//
//

import Foundation

/// Description for an Endpoint in an API
public protocol APIEndpoint {
    /// Raw value string for the key
    var rawValue: String { get }
}

extension APIEndpoint {
    
    /// For the lazy. Creates a simple API object for your reference
    public static func api(with url: String, baseHeaders: [String:String] = [:], baseQueries: [String:String] = [:]) -> GenericAPI<Self> {
        return GenericAPI(baseURL: url, baseHeaders: baseHeaders, baseQueries: baseQueries)
    }
    
}

/// Generic easy to make API from an Endpoint Description
public struct GenericAPI<E: APIEndpoint>: API {
    
    public typealias Endpoint = E
    public let baseURL: String
    public let baseHeaders: [String:String]
    public let baseQueries: [String:String]
    
    init(baseURL: String, baseHeaders: [String:String] = [:], baseQueries: [String:String] = [:]) {
        self.baseURL = baseURL
        self.baseHeaders = baseHeaders
        self.baseQueries = baseQueries
    }
    
}
