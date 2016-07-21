//
//  TumOnlineLoginRequestManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class TumOnlineLoginRequestManager {
    
    init(delegate:AccessTokenReceiver?) {
        self.delegate = delegate
    }
    
    var token = ""
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var delegate: AccessTokenReceiver?
    
    var lrzID : String?
    
    func newId(newId: String) {
        lrzID = newId
    }
    
    func getLoginURL() -> String {
        let version = (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String) ?? "1"
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.TokenRequest.rawValue
        if let id = lrzID {
            return  base + "?pUsername=" + id + "&pTokenName=TumCampusApp-" + version
        }
        return ""
    }
    
    func getConfirmationURL() -> String {
        return TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.TokenConfirmation.rawValue + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token
    }
    
    func fetch() {
        let url = getLoginURL()
        print(url)
        Alamofire.request(.GET, url).responseString() { (response) in
            if let data = response.result.value {
                let tokenData = SWXMLHash.parse(data)
                if let token = tokenData["token"].element?.text {
                    self.token = token
                }
            }
        }
    }
    
    func confirmToken() {
        let url = getConfirmationURL()
        print(url)
        Alamofire.request(.GET, url).responseString() { (response) in
            if let data = response.result.value {
                let tokenData = SWXMLHash.parse(data)
                print(tokenData)
                if let confirmed = tokenData["confirmed"].element?.text {
                    if confirmed == "true" {
                        self.delegate?.receiveToken(self.token)
                    } else {
                        self.delegate?.tokenNotConfirmed()
                    }
                } else {
                    self.delegate?.tokenNotConfirmed()
                }
            } else {
                self.delegate?.tokenNotConfirmed()
            }
        }
    }
    
    func userFromStorage() -> User? {
        let token = defaults.stringForKey(LoginDefaultsKeys.Token.rawValue)
        let id = defaults.stringForKey(LoginDefaultsKeys.LRZ.rawValue)
        if let idUnwrapped = id, tokenUnwrapped = token {
            return User(lrzID: idUnwrapped, token: tokenUnwrapped)
        }
        return nil
    }
    
    func LoginSuccesful(user: User) {
        defaults.setObject(user.token, forKey: LoginDefaultsKeys.Token.rawValue)
        defaults.setObject(user.lrzID, forKey: LoginDefaultsKeys.LRZ.rawValue)
    }
    
    func logOut() {
        defaults.removeObjectForKey(LoginDefaultsKeys.LRZ.rawValue)
        defaults.removeObjectForKey(LoginDefaultsKeys.Token.rawValue)
    }
    
    
}