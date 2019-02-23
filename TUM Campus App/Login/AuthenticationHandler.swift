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

/// Handles authentication for TUMOnline, TUMCabe and the MVGAPI
class AuthenticationHandler: RequestAdapter, RequestRetrier {
    typealias Completion = (Result<String>) -> Void
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    var delegate: AuthenticationHandlerDelegate?
    
    lazy var sessionManager: SessionManager = {
        let manager = SessionManager()
        manager.adapter = AuthenticationHandler(delegate: nil)
        manager.retrier = AuthenticationHandler(delegate: nil)
        return manager
    }()
    
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
    
    // MARK: - Initialization
    
    public init(delegate: AuthenticationHandlerDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
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
        case urlString where TUMOnlineAPI.requiresAuth.contains { urlString.hasSuffix($0) }:
            return try URLEncoding.default.encode(urlRequest, with: ["pToken": pToken])
        case urlString where TUMCabeAPI.requiresAuth.contains { urlString.hasSuffix($0)}:
            return urlRequest
        case urlString where urlString.hasPrefix(MVGAPI.baseURL):
            urlRequest.addValue(MVGAPI.apiKey, forHTTPHeaderField: "X-MVG-Authorization-Key")
        default:
            break
        }
        return urlRequest
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
    
    // TODO: Migrate data from old tum campus app
    
    func createToken(tumID: String, completion: @escaping Completion) {
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
    
    func confirmToken(callback: @escaping (Result<Bool>) -> Void) {
        switch credentials {
        case .none: callback(.failure(LoginError.missingToken))
        case .noTumID?: callback(.failure(LoginError.missingToken))
        case .tumID(_, let token)?,
             .tumIDAndKey(_,let token, _)?:
            sessionManager.request(TUMOnlineAPI.tokenConfirmation).responseXML { xml in
                if xml.value?["confirmed"].element?.text == "true" {
                    callback(.success(true))
                } else if xml.value?["confirmed"].element?.text == "false" {
                    callback(.failure(LoginError.invalidToken))
                } else {
                    callback(.failure(LoginError.unknown))
                }
            }
        }
    }
    
    func createKey() throws -> Data {
        //        let tag = "com.example.keys.mykey".data(using: .utf8)!
        let attributes: [String: Any] =
            [kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
             kSecAttrKeySizeInBits as String: 2048,
             //             kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: true,
                //                                             kSecAttrApplicationTag as String: tag]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        guard let cfdata = SecKeyCopyExternalRepresentation(privateKey, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        let data = cfdata as Data
        
        switch credentials {
        case .tumID(let tumID, let token)?: credentials = .tumIDAndKey(tumID: tumID, token: token, key: data)
        case .tumIDAndKey(let tumID, let token, _)?: credentials = .tumIDAndKey(tumID: tumID, token: token, key: data)
        default: break
        }
        
        return data
    }
    
    func uploadKey(callback: @escaping (Result<Data>) -> Void) {
        let key = try? createKey()
    }
    
    func registerKey(callback: @escaping (Result<Bool>) -> Void) {
        // TOOD
    }
    
    func logout() {
        credentials = nil
        // delete user data!
    }
    
    func skipLogin() {
        credentials = .noTumID
    }
    
    
}
