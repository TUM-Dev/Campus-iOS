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
    
    private static var keychain = Keychain(service: "de.tum.tumonline")
    private(set) var tumID: String? {
        get { return LoginController.keychain["tumID"] }
        set {
            if let newValue = newValue {
                LoginController.keychain["tumID"] = newValue
            } else {
                LoginController.keychain["tumID"] = nil
            }
        }
    }
    private(set) var token: String? {
        get { return LoginController.keychain["token"] }
        set {
            if let newValue = newValue {
                LoginController.keychain["token"] = newValue
            } else {
                LoginController.keychain["token"] = nil
            }
        }
    }
    private(set) var key = {
        //TOOD
    }
    
    
    func createToken(tumID: String, callback: @escaping Callback<String>) {
        let tokenName = "TCA - \(UIDevice.current.name)"
        
        Alamofire.request(TUMOnlineAPI.tokenRequest(tumID: tumID, tokenName: tokenName)).responseXML { xml in
            guard let newToken = xml.value?["token"].element?.text else {
                callback(.failure(LoginError.invalidToken))
                return
            }
            
            self.token = newToken
            callback(.success(newToken))
        }
    }
    
    func confirmToken(callback: @escaping Callback<Bool>) {
        guard let token = token else {
            callback(.failure(LoginError.missingToken))
            return // Or maybe handle the error???
        }
        
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
    
    func uploadKey() {
        // TOOD
    }
    
    func registerKey() {
        // TOOD
    }
    
    func logout() {
        tumID = nil
        token = nil
    }
    
    func skipLogin() {
        // save to keychain
    }
    
}
