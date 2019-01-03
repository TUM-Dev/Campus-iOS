//
//  LoginController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import UIKit
import Alamofire

class LoginController {
    
    func login() {
        // Check if there is already a token...
        // createToken()
        // confirmToken()
    }
    
    private func createToken() {
        let tokenName = "TCA - \(UIDevice.current.name)"
        let lrzID = "ga94zuh"
        
        Alamofire.request(TUMOnlineAPI.tokenRequest(tumID: lrzID, tokenName: tokenName)).responseXML { xml in
            guard let token = xml.value?["token"].element?.text else {
                return //Error
            }
        }
                                                            
        
//        self.loginStarted(with: token)
//        return self.confirm(token: token)
    }
    
    private func confirmToken() {
        // confirm Token
        // update Model
        // fetchUserData()
    }
    
    func logout() {
        // updateModel
    }
    
    func fetchUserData() {
        
    }
    
    
}
