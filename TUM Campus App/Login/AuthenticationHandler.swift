//
//  AuthenticationHandler.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/17/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash
import KeychainAccess

protocol AuthenticationHandlerDelegate {
    func shouldEnterTumID() -> String?
    func shouldEnableTokenPermissions()
    func shouldActivateToken()
}

/// Handles authentication for both TUMOnline and TUMCabe
class AuthenticationHandler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (Result<String>) -> Void

    private static let keychain = Keychain(service: "de.tum.tumonline")
        .synchronizable(true)
        .accessibility(.afterFirstUnlock)
    
    private(set) var credentials: Credentials? {
        get {
            guard let data = AuthenticationHandler.keychain[data: "credentials"] else { return nil }
            return try? PropertyListDecoder().decode(Credentials.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try! PropertyListEncoder().encode(newValue)
                AuthenticationHandler.keychain[data: "credentials"] = data
            } else {
                AuthenticationHandler.keychain[data: "credentials"] = nil
            }
        }
    }
    
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    var delegate: AuthenticationHandlerDelegate?
    
    // MARK: - Initialization
    
    public init(delegate: AuthenticationHandlerDelegate?) {
       self.delegate = delegate
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard let urlString = urlRequest.url?.absoluteString else { return urlRequest }
        var pToken: String

        switch credentials {
        case .tumID(_, let token)?,
             .tumIDAndKey(_, let token, _)?:
            pToken = token
        default:
            throw LoginError.missingToken
        }
        
        switch urlString {
        case urlString where urlString.hasPrefix(TUMOnlineAPI.baseURLString):
            return try URLEncoding.default.encode(urlRequest, with: ["pToken": pToken])
        case urlString where urlString.hasPrefix(TUMCabeAPI.baseURLString):
            // TODO
            fallthrough
        default:
            return urlRequest
        }
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        // TODO status code is 200 so this doesn't work
        
        if let data = request.delegate.data {
            let xml = SWXMLHash.parse(data)
            
            // TODO
            
            /*
             Decide if token is invalid or not authorized:
             
             <?xml version="1.0" encoding="utf-8"?>
             <error>
             <message>Token ist ungültig!</message>
             </error>
             
             <?xml version="1.0" encoding="utf-8"?>
             <error>
             <message>Token ist nicht bestätigt!</message>
             </error>
             
             */
        }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            var tumID: String
            requestsToRetry.append(completion)
            
            guard isRefreshing else {
                completion(false, 0.0)
                return
            }
            
            switch credentials {
            case .none,
                 .noTumID?:
                guard let delegate = delegate else { return }
                guard let id = delegate.shouldEnterTumID() else { return }
                tumID = id
            case .tumID(let id,_)?,
                 .tumIDAndKey(let id,_,_)?:
                tumID = id
            }
            
            createToken(tumID: tumID) { [weak self] result in
                guard let strongSelf = self else { return }
                let shouldRetry: Bool
                strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                
                switch result {
                case .success(let token):
                    // Auth succeeded retry failed request.
                    shouldRetry = true
                    switch strongSelf.credentials {
                    case .none: strongSelf.credentials = .tumID(tumID: tumID, token: token)
                    case .noTumID?: strongSelf.credentials = .tumID(tumID: tumID, token: token)
                    case .tumID(let tumID, _)?: strongSelf.credentials = .tumID(tumID: tumID, token: token)
                    case .tumIDAndKey(let tumID, _, let key)?: strongSelf.credentials = .tumIDAndKey(tumID: tumID, token: token, key: key)
                    }
                    
                default:
                    // Auth failed don't retry.
                    shouldRetry = false
                    break
                }
                
                strongSelf.requestsToRetry.forEach { $0(shouldRetry, 0.0) }
                strongSelf.requestsToRetry.removeAll()
            }
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func createToken(tumID: String, completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        let tokenName = "TCA - \(UIDevice.current.name)"
        
        Alamofire.request(TUMOnlineAPI.tokenRequest(tumID: tumID, tokenName: tokenName)).responseXML { [weak self] xml in
            guard let strongSelf = self else { return }
            guard let newToken = xml.value?["token"].element?.text else {
                completion(.failure(LoginError.invalidToken))
                return
            }
            strongSelf.credentials = Credentials.tumID(tumID: tumID, token: newToken)
            completion(.success(newToken))
            strongSelf.isRefreshing = false
        }
    }
    

}
