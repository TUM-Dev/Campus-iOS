//
//  OAuth.swift
//  Pods
//
//  Created by Mathias Quintero on 1/4/17.
//
//

import Foundation

public final class OAuth: Auth, Observable {
    
    public var listeners = [Listener]()
    
    var token: String
    var tokenType: String
    var refreshToken: String?
    var expirationDate: Date?
    var manager: OAuthManager<OAuthEndpoint>?
    var endpoint: OAuthEndpoint?
    private var refreshPromise: OAuth.Result?
    
    init(token: String, tokenType: String, refreshToken: String?, expirationDate: Date?, manager: OAuthManager<OAuthEndpoint>? = nil, endpoint: OAuthEndpoint? = nil) {
        self.token = token
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expirationDate = expirationDate
        self.manager = manager
        self.endpoint = endpoint
    }
    
    public func update(with auth: OAuth) {
        token = auth.token
        tokenType = auth.tokenType
        refreshToken = auth.refreshToken
        expirationDate = auth.expirationDate
        hasChanged()
    }
    
    public var isExpired: Bool {
        guard let expirationDate = expirationDate else {
            return false
        }
        return expirationDate < .now
    }
    
    public var isRefreshable: Bool {
        return ??refreshToken && ??expirationDate
    }
    
    public func refresh() -> OAuth.Result {
        guard let manager = manager, let endpoint = endpoint else {
            return .errored(with: .cannotPerformRequest)
        }
        return manager.refresh(at: endpoint, with: self)
    }
    
    public func apply(to request: URLRequest) -> Promise<URLRequest, APIError> {
        if isExpired {
            refreshPromise = self.refreshPromise ?? refresh()
            return refreshPromise?.onSuccess { (auth: OAuth) -> Promise<URLRequest, APIError> in
                self.refreshPromise = nil
                self.update(with: auth)
                return self.apply(to: request)
                }
                .future ?? .errored(with: .cannotPerformRequest)
        }
        var request = request
        request.addValue("\(tokenType) \(token)", forHTTPHeaderField: "Authorization")
        return .successful(with: request)
    }
    
}

extension OAuth: Deserializable {
    
    public convenience init?(from json: JSON) {
        guard let token = json["access_token"].string,
            let tokenType = json["token_type"].string else {
                return nil
        }
        self.init(token: token,
                  tokenType: tokenType,
                  refreshToken: json["refresh_token"].string,
                  expirationDate: json["expires_in"].dateInDistanceFromNow,
                  manager: nil,
                  endpoint: nil)
    }
    
}

extension OAuth: StatusSerializable {
    
    public convenience init?(from status: [String : Any]) {
        guard let token = status["token"] as? String,
            let tokenType = status["tokenType"] as? String else {
                return nil
        }
        let managerStatus = status["manager"] as? [String:Any] ?? .empty
        let endpoint = (status["endpoint"] as? String) | OAuthEndpoint.init(rawValue:)
        self.init(token: token, tokenType: tokenType, refreshToken: (status["refresh"] as? String),
                  expirationDate: (status["expiration"] as? String)?.date(),
                  manager: OAuthManager<OAuthEndpoint>(from: managerStatus),
                  endpoint: endpoint)
    }
    
    public var serialized: [String : Any] {
        var dict: [String:Any] = [
            "token": token,
            "tokenType": tokenType
        ]
        dict["refresh"] <- refreshToken
        dict["expiration"] <- expirationDate?.string()
        dict["endpoint"] <- endpoint?.rawValue
        dict["manager"] <- manager?.serialized
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
