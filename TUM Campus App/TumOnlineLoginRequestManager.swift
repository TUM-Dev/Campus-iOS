//
//  TumOnlineLoginRequestManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import SWXMLHash

class TumOnlineLoginRequestManager {
    
    enum State {
        case creatingToken(lrzID: String)
        case waiting(lrzID: String, token: String)
    }
    
    let config: Config

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
    
    init(config: Config) {
        self.config = config
    }
    
    private func confirm(token: String) -> Response<Bool> {
        return config.tumOnline.doRepresentedRequest(to: .tokenConfirmation,
                                                     queries: ["pToken" : token]).map { (xml: XMLIndexer) in
                                                        
            return xml["confirmed"].element?.text == "true"
        }.onSuccess { success in
            if success {
                self.loginSuccesful()
            }
        }
    }
    
    private func start(id: String) -> Response<Bool> {
        return config.tumOnline.doRepresentedRequest(to: .tokenRequest,
                                                     queries: [
                                                        "pUsername" : id,
                                                        "pTokenName" : "TumCampusApp-\(Bundle.main.version)"
                                                     ]).flatMap { (xml: XMLIndexer) in
            
                guard let token = xml["token"].element?.text else {
                    return .successful(with: false)
                }
                self.loginStarted(with: token)
                return self.confirm(token: token)
        }
    }
    
    func fetch() -> Response<Bool> {
        return state.map { state in
            switch state {
            case .creatingToken(let id):
                return self.start(id: id)
            case .waiting(_, let token):
                return self.confirm(token: token)
            }
        } ?? .errored(with: .cannotPerformRequest)
    }
    
    func loginStarted(with token: String) {
        guard case .some(.creatingToken(let lrzID)) = self.state else {
            return
        }
        PersistentUser.value = .some(lrzID: lrzID, token: token, state: .awaitingConfirmation)
    }
    
    func loginSuccesful() {
        guard case .some(.waiting(let lrzID, let token)) = self.state else {
            return
        }
        PersistentUser.value = .some(lrzID: lrzID, token: token, state: .loggedIn)
        config.tumOnline.user = PersistentUser.value.user
    }
    
    func logOut() {
        config.clearCache()
        PersistentUser.reset()
        config.tumOnline.user = nil
        Usage.value = false
    }
    
}
