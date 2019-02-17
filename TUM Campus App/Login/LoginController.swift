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
        case .tumID(_, let token)?, .tumIDAndKey(_,let token, _)?:
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
    
    func createKey() {
        // TODO
    }
    
    func uploadKey() {
        // TOOD
    }
    
    func registerKey() {
        // TOOD
    }
    
    func logout() {
        credentials = nil
    }
    
    func skipLogin() {
        credentials = .noTumID
    }
    
}
