//
//  LoginController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

enum LoginError: Error {
    case missingToken
    case invalidToken
}

class LoginController {
    
    private(set) var tumID: String? {
        get { return KeychainWrapper.standard.string(forKey: "tumID") }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "tumID")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "tumID")
            }
        }
    }
    private(set) var token: String? {
        get { return KeychainWrapper.standard.string(forKey: "token") }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "token")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "token")
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
