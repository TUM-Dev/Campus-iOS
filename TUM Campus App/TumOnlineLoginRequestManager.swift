//
//  TumOnlineLoginRequestManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import Alamofire
import SWXMLHash

// TODO: Refactor this

class TumOnlineLoginRequestManager {
    
    enum State {
        case creatingToken(lrzID: String)
        case waiting(lrzID: String, token: String)
    }
    
    init(delegate: AccessTokenReceiver?) {
        self.delegate = delegate
    }
    
    weak var delegate: AccessTokenReceiver?

    var state: State? {
        switch PersistentUser.value {
        case .requestingToken(let lrzID):
            return .creatingToken(lrzID: lrzID)
        case .some(let lrzID, let token, state: .awaitingConfirmation):
            return .waiting(lrzID: lrzID, token: token)
        default:
            return nil
        }
    }
    
    var token: String? {
        guard case .some(.waiting(_, let token)) = state else {
            return nil
        }
        return token
    }
    
    var lrzID : String? {
        
        switch state {
        case .some(.creatingToken(let lrzID)):
            return lrzID
        case .some(.waiting(let lrzID, _)):
            return lrzID
        default:
            return nil
        }
    }
    
    func getLoginURL() -> String {
        let version = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.TokenRequest.rawValue
        if let id = lrzID {
            return  base + "?pUsername=" + id + "&pTokenName=TumCampusApp-" + version
        }
        return ""
    }
    
    func getConfirmationURL() -> String {
        return TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.TokenConfirmation.rawValue + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + (token.?)
    }
    
    func fetch() {
        let url = getLoginURL()
        Alamofire.request(url).responseString() { (response) in
            if let data = response.result.value {
                let tokenData = SWXMLHash.parse(data)
                if let token = tokenData["token"].element?.text {
                    self.loginStarted(with: token)
                }
            }
        }
    }
    
    func confirmToken() {
        let url = getConfirmationURL()
        Alamofire.request(url).responseString() { (response) in
            if let data = response.result.value {
                let tokenData = SWXMLHash.parse(data)
                if let confirmed = tokenData["confirmed"].element?.text {
                    if confirmed == "true" {
                        self.loginSuccesful()
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
    
    func loginStarted(with token: String) {
        guard case .some(.creatingToken(let lrzID)) = self.state else {
            return
        }
        PersistentUser.value = .some(lrzID: lrzID, token: token, state: .awaitingConfirmation)
        confirmToken()
    }
    
    func loginSuccesful() {
        guard case .some(.waiting(let lrzID, let token)) = self.state else {
            return
        }
        PersistentUser.value = .some(lrzID: lrzID, token: token, state: .loggedIn)
        User.shared = PersistentUser.value.user
        delegate?.receiveToken(token)
    }
    
    func logOut() {
        PersistentUser.reset()
        User.shared = nil
    }
    
}
