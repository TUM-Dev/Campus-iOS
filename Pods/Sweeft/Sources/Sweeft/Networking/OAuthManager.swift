//
//  File.swift
//  Pods
//
//  Created by Mathias Quintero on 2/27/17.
//
//

import Foundation

public struct OAuthManager<V: APIEndpoint>: API {
    
    public typealias Endpoint = V
    public let baseURL: String
    public let clientID: String
    public let secret: String
    public let useBasicHttp: Bool
    public let useJSON: Bool
    
    public init(baseURL: String, clientID: String, secret: String, useBasicHttp: Bool = true, useJSON: Bool = false) {
        self.baseURL = baseURL
        self.clientID = clientID
        self.secret = secret
        self.useBasicHttp = useBasicHttp
        self.useJSON = useJSON
    }
    
    func auth() -> Auth {
        if useBasicHttp {
            return BasicAuth(username: clientID, password: secret)
        } else {
            return NoAuth.standard
        }
    }
    
    func body(with grant: Grant) -> [String:String] {
        var dict = grant.dict.dictionaryWithoutOptionals(byDividingWith: id)
        if !useBasicHttp {
            dict["client_id"] = clientID
            dict["client_secret"] = secret
        }
        return dict
    }
    
    private func jsonRequest(to endpoint: Endpoint, auth: Auth, body: [String: String]) -> OAuth.Result {
        return doObjectRequest(with: .post,
                               to: endpoint,
                               auth: auth,
                               body: body.mapValues({ $0.json }).json)
    }
    
    private func queriedRequest(to endpoint: Endpoint, auth: Auth, body: [String:String]) -> OAuth.Result {
        return doObjectRequest(with: .post, to: endpoint, queries: body, auth: auth)
    }
    
    private func applyRefresher(to auth: OAuth, with endpoint: Endpoint) -> OAuth {
        let refresher = OAuthManager<OAuthEndpoint>(baseURL: baseURL,
                                                    clientID: clientID,
                                                    secret: secret,
                                                    useBasicHttp: useBasicHttp,
                                                    useJSON: useJSON)
        auth.manager = refresher
        auth.endpoint = OAuthEndpoint(rawValue: endpoint.rawValue)
        return auth
    }
    
    private func requestAuth(to endpoint: Endpoint, with grant: Grant) -> OAuth.Result {
        let auth = self.auth()
        let body = self.body(with: grant)
        if useJSON {
            return jsonRequest(to: endpoint, auth: auth, body: body).nested(self.applyRefresher <** endpoint)
        } else {
            return queriedRequest(to: endpoint, auth: auth, body: body).nested(self.applyRefresher <** endpoint)
        }
    }
    
    private func authenticate(at endpoint: Endpoint, with json: JSON) -> OAuth.Result {
        if let auth = OAuth(from: json) {
            return .successful(with: auth)
        }
        if let authorizationCode = json["code"].string {
            return authenticate(at: endpoint, authorizationCode: authorizationCode)
        }
        return .errored(with: .mappingError(json: json))
    }
    
    public func refresh(at endpoint: Endpoint, with auth: OAuth) -> OAuth.Result {
        return requestAuth(to: endpoint, with: .refreshToken(token: auth.refreshToken))
    }
    
    public func authenticate(at endpoint: Endpoint, callback url: URL) -> OAuth.Result {
        if let fragment = url.fragment {
            let json = JSON(fragment: fragment)
            return authenticate(at: endpoint, with: json)
        } else if let query = url.query {
            let json = JSON(fragment: query)
            return authenticate(at: endpoint, with: json)
        }
        return .errored(with: .cannotPerformRequest)
    }
    
    public func authenticate(at endpoint: Endpoint, authorizationCode code: String) -> OAuth.Result {
        return requestAuth(to: endpoint, with: .authorizationCode(code: code))
    }
    
    public func authenticate(at endpoint: Endpoint, username: String, password: String, scope: String...) -> OAuth.Result {
        let scope = scope.isEmpty ? nil : scope.join(with: " ")
        let grant: Grant = .password(username: username, password: password, scope: scope)
        return requestAuth(to: endpoint, with: grant)
    }
    
}

public extension API {
    
    func oauthManager(clientID: String, secret: String, useBasicHttp: Bool = true, useJSON: Bool = false) -> OAuthManager<Self.Endpoint> {
        return OAuthManager(baseURL: self.baseURL, clientID: clientID, secret: secret, useBasicHttp: useBasicHttp, useJSON: useJSON)
    }
    
}

public struct OAuthEndpoint: APIEndpoint {
    public let rawValue: String
}

extension OAuthEndpoint: StatusSerializable {
    
    public init?(from status: [String : Any]) {
        guard let rawValue = status["endpoint"] as? String else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    
    public var serialized: [String : Any] {
        return [
            "endpoint": rawValue
        ]
    }
    
}

extension OAuthManager: StatusSerializable {
    
    public init?(from status: [String : Any]) {
        guard let baseURL = status["url"] as? String,
            let clientID = status["client"] as? String,
            let secret = status["secret"] as? String,
            let basic = status["basic"] as? Bool,
            let json = status["json"] as? Bool else {
                return nil
        }
        self.init(baseURL: baseURL, clientID: clientID, secret: secret, useBasicHttp: basic, useJSON: json)
    }
    
    public var serialized: [String : Any] {
        return [
            "url": baseURL,
            "client": clientID,
            "secret": secret,
            "basic": useBasicHttp,
            "json": useJSON
        ]
    }
    
}
