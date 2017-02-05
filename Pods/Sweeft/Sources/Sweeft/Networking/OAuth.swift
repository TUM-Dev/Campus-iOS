//
//  OAuth.swift
//  Pods
//
//  Created by Mathias Quintero on 1/4/17.
//
//

import Foundation

public struct OAuthEndpoint: APIEndpoint {
    public let rawValue: String
}

public struct OAuthManager: API {
    
    public typealias Endpoint = OAuthEndpoint
    public let baseURL: String
    public let clientID: String
    public let secret: String
    
    public init(baseURL: String, clientID: String, secret: String) {
        self.baseURL = baseURL
        self.clientID = clientID
        self.secret = secret
    }
    
    func body(username: String, password: String, scope: String?) -> JSON {
        return [
            "grant_type": "password",
            "client_id": clientID.json,
            "client_secret": secret.json,
            "username": username.json,
            "password": password.json,
            "scope": (scope?.json).?
        ]
    }
    
    public func authenticate(at url: String, username: String, password: String, scope: String...) -> OAuth.Result {
        let endpoint = OAuthEndpoint(rawValue: url)
        let auth = BasicAuth(username: username, password: password)
        let scope = scope.isEmpty ? nil : scope.join(with: " ")
        let body = self.body(username: username, password: password, scope: scope)
        return doObjectRequest(with: .post, to: endpoint, auth: auth, body: body)
    }
    
}

public struct OAuth: Auth {
    
    fileprivate let token: String
    fileprivate let tokenType: String
    fileprivate let refreshToken: String?
    fileprivate let expirationDate: Date?
    
    var isExpired: Bool {
        guard let expirationDate = expirationDate else {
            return false
        }
        return expirationDate < .now
    }
    
    public func refresh() {
        
    }
    
    public func apply(to request: inout URLRequest) {
        if isExpired {
            refresh()
        }
        request.addValue("\(tokenType) \(token)", forHTTPHeaderField: "Authorization")
    }
    
}

extension OAuth: Deserializable {
    
    public init?(from json: JSON) {
        guard let token = json["access_token"].string,
            let tokenType = json["token_type"].string else {
                return nil
        }
        self.init(token: token, tokenType: tokenType,
                  refreshToken: json["refresh_token"].string, expirationDate: nil)
    }
    
}

extension OAuth: StatusSerializable {
    
    public init?(from status: [String : Any]) {
        guard let token = status["token"] as? String,
            let tokenType = status["tokenType"] as? String else {
                return nil
        }
        self.init(token: token, tokenType: tokenType, refreshToken: (status["refresh"] as? String),
                  expirationDate: (status["expiration"] as? String)?.date())
    }
    
    public var serialized: [String : Any] {
        var dict = [
            "token": token,
            "tokenType": tokenType
        ]
        dict["refresh"] <- refreshToken
        dict["expiration"] <- expirationDate?.string()
        return dict
    }
    
}

extension OAuth {
    
    public func store(using key: String) {
        OAuthStatus.key = OAUTHStatusKey(name: key)
        OAuthStatus.value = self
    }
    
    public static func stored(with key: String) -> OAuth? {
        OAuthStatus.key = OAUTHStatusKey(name: key)
        return OAuthStatus.value
    }
    
}

struct OAUTHStatusKey: StatusKey {
    let name: String
    
    var rawValue: String {
        return "OAUTH-\(name)"
    }
}

struct OAuthStatus: OptionalStatus {
    typealias Value = OAuth
    static var key = OAUTHStatusKey(name: "shared")
}
