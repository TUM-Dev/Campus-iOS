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
}

class LoginController {
    
    private(set) var tumID: String? {
        get {
            let keychain = Keychain(service: "de.tum.tumonline")
            return keychain["tumID"]
        }
        set {
            let keychain = Keychain(service: "de.tum.tumonline")
            if let newValue = newValue {
                keychain["tumID"] = newValue
            } else {
                keychain["tumID"] = nil
            }
        }
    }
    private(set) var token: String? {
        get {
            let keychain = Keychain(service: "de.tum.tumonline")
            return keychain["token"]
        }
        set {
            let keychain = Keychain(service: "de.tum.tumonline")
            if let newValue = newValue {
                keychain["token"] = newValue
            } else {
                keychain["token"] = nil
            }
        }
    }
    private(set) var key = {
        //TOOD
    }
    
    
    func createToken(tumID: String) throws {
        let tokenName = "TCA - \(UIDevice.current.name)"
        
        Alamofire.request(TUMOnlineAPI.tokenRequest(tumID: tumID, tokenName: tokenName)).responseXML { xml in
            guard let token = xml.value?["token"].element?.text else {
//                return .failure(LoginError.invalidToken)
                return
            }
        }
    }
    
    func confirmToken() throws {
        guard let token = token else {
            throw LoginError.missingToken
        }
        
        Alamofire.request(TUMOnlineAPI.tokenConfirmation(token: token)).responseXML { xml in
            
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
    
}
