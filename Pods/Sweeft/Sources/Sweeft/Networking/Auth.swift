//
//  Auth.swift
//  Pods
//
//  Created by Mathias Quintero on 12/29/16.
//
//

import Foundation

/// Authentication protocol
public protocol Auth {
    func apply(to request: URLRequest) -> Promise<URLRequest, APIError>
}

/// Object that doesn't do anything to authenticate the user
public struct NoAuth: Auth {
    
    /// Shared instance
    public static let standard = NoAuth()
    
    public func apply(to request: URLRequest) -> Promise<URLRequest, APIError> {
        return .successful(with: request)
    }
    
}

/// Basic Http Auth
public struct BasicAuth {
    
    fileprivate let username: String
    fileprivate let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
}

extension BasicAuth: Auth {
    
    /// Adds authorization header
    public func apply(to request: URLRequest) -> Promise<URLRequest, APIError> {
        var request = request
        let string = ("\(username):\(password)".base64Encoded).?
        let auth = "Basic \(string)"
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        return .successful(with: request)
    }
    
}
