//
//  LoginController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess

enum LoginError: Error {
    case missingToken
    case invalidToken
    case unknown
}

class LoginController {
    
    typealias Callback<T> = (Result<T>) -> ()
    
    private static let keychain = Keychain(service: "de.tum.tumonline")
        .synchronizable(true)
        .accessibility(.afterFirstUnlock)
    
    private(set) var credentials: Credentials? {
        get {
            guard let data = LoginController.keychain[data: "credentials"] else { return nil }
            return try? PropertyListDecoder().decode(Credentials.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try! PropertyListEncoder().encode(newValue)
                LoginController.keychain[data: "credentials"] = data
            } else {
                LoginController.keychain[data: "credentials"] = nil
            }
        }
    }
    
    func createToken(tumID: String, callback: @escaping Callback<String>) {
        let tokenName = "TCA - \(UIDevice.current.name)"
        
        Alamofire.request(TUMOnlineAPI.tokenRequest(tumID: tumID, tokenName: tokenName)).responseXML { xml in
            guard let newToken = xml.value?["token"].element?.text else {
                callback(.failure(LoginError.invalidToken))
                return
            }
            self.credentials = Credentials.tumID(tumID: tumID, token: newToken)
            callback(.success(newToken))
        }
    }
    
    func confirmToken(callback: @escaping Callback<Bool>) {
        switch credentials {
        case .none: callback(.failure(LoginError.missingToken))
        case .noTumID?: callback(.failure(LoginError.missingToken))
        case .tumID(_, let token)?,
             .tumIDAndKey(_,let token, _)?:
            Alamofire.request(TUMOnlineAPI.tokenConfirmation(token: token)).responseXML { xml in
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
    
    func uploadKey(callback: @escaping Callback<Data>) {
        let key = try? createKey()
    }
    
    func registerKey(callback: @escaping Callback<Bool>) {
        // TOOD
    }
    
    func logout() {
        credentials = nil
    }
    
    func skipLogin() {
        credentials = .noTumID
    }
    
}
