//
//  TUMOnlineAPI.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft
import SWXMLHash

enum TUMOnlineEndpoint: String, APIEndpoint {
    case personSearch = "wbservicesbasic.personenSuche"
    case tokenRequest = "wbservicesbasic.requestToken"
    case tokenConfirmation = "wbservicesbasic.isTokenConfirmed"
    case tuitionStatus = "wbservicesbasic.studienbeitragsstatus"
    case calendar = "wbservicesbasic.kalender"
    case personDetails = "wbservicesbasic.personenDetails"
    case personalLectures = "wbservicesbasic.veranstaltungenEigene"
    case personalGrades = "wbservicesbasic.noten"
    case lectureSearch = "wbservicesbasic.veranstaltungenSuche"
    case lectureDetails = "wbservicesbasic.veranstaltungenDetails"
    case identify = "wbservicesbasic.id"
}

final class TUMOnlineAPI: API {
    
    enum Error: Swift.Error {
        case invalidToken
        case unknwon(String)
    }
    
    typealias Endpoint = TUMOnlineEndpoint
    
    let baseURL: String
    var user: User?
    private var errorHandlers = [(Error) -> ()]()
    private let queue = DispatchQueue(label: "de.tum.campusapp.TUMOnlineAPI")
    
    var baseQueries: [String : String] {
        guard let token = user?.token else {
            return .empty
        }
        return [
            "pToken": token
        ]
    }
    
    init(baseURL: String, user: User?) {
        self.baseURL = baseURL
        self.user = user
    }
    
    func onError(call handler: @escaping (Error) -> ()) {
        queue.async(flags: .barrier) {
            self.errorHandlers.append(handler)
        }
    }
    
    func handle(error: Error, from method: HTTPMethod, at endpoint: TUMOnlineEndpoint) {
        removeCache(for: endpoint)
        let errorHandlers = queue.sync { self.errorHandlers }
        errorHandlers.forEach { $0(error) }
    }
    
}

extension TUMOnlineAPI.Error {
    
    init(message: String) {
        
        switch message {
        case "Token ist nicht bestätigt oder ungültig!":
            self = .invalidToken
        default:
            self = .unknwon(message)
        }
    }
    
}
