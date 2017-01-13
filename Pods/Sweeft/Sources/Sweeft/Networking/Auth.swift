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
    func apply(to request: inout URLRequest)
}

/// Object that doesn't do anything to authenticate the user
public struct NoAuth: Auth {
    
    /// Shared instance
    static let standard = NoAuth()
    
    public func apply(to request: inout URLRequest) {
        // Do Nothing
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
    public func apply(to request: inout URLRequest) {
        let string = ("\(username):\(password)".base64Encoded).?
        let auth = "Basic \(string)"
        request.addValue(auth, forHTTPHeaderField: "Authorization")
    }
    
}
