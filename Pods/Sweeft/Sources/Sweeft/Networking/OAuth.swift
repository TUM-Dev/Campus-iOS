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
        var dict = [
            "grant_type": "password",
            "client_id": clientID,
            "client_secret": secret,
            "username": username,
            "password": password
        ]
        dict["scope"] <- scope
        return .dict(dict >>= mapLast(with: JSON.init))
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
        self.init(token: token, tokenType: tokenType, refreshToken: (status["refresh"] as? String), expirationDate: (status["expiration"] as? String)?.date())
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
        OAuthStatus.value = .some(value: self)
    }
    
    public static func stored(with key: String) -> OAuth? {
        OAuthStatus.key = OAUTHStatusKey(name: key)
        return OAuthStatus.value.auth
    }
    
}

enum OAuthStatusValue: StatusSerializable {
    case none
    case some(value: OAuth)
    
    public init?(from status: [String : Any]) {
        if let value = OAuth(from: status) {
            self = .some(value: value)
        } else {
            self = .none
        }
    }
    
    public var serialized: [String : Any] {
        switch self {
        case .none:
            return [:]
        case .some(let value):
            return value.serialized
        }
    }
    
    var auth: OAuth? {
        switch self {
        case .none:
            return nil
        case .some(let value):
            return value
        }
    }
}

struct OAUTHStatusKey: StatusKey {
    let name: String
    
    var rawValue: String {
        return "OAUTH-\(name)"
    }
}

struct OAuthStatus: ObjectStatus {
    static var key = OAUTHStatusKey(name: "shared")
    static var defaultValue: OAuthStatusValue = .none
}
