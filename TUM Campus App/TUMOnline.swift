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
}

struct TUMOnlineAPI: API {
    
    typealias Endpoint = TUMOnlineEndpoint
    
    let baseURL: String
    let user: User?
    
    var baseQueries: [String : String] {
        guard let token = user?.token else {
            return .empty
        }
        return [
            "pToken": token
        ]
    }
    
}

extension TUMOnlineAPI {
    
    func token(for id: String) -> String.Result {
        
        let version = Bundle.main.version
        return doRepresentedRequest(to: .tokenRequest,
                                    queries: [
                                        "pUsername": id,
                                        "pTokenName": "TumCampusApp-\(version)"
                                    ]).nested { (xml: XMLIndexer, promise) in
            
            guard let token = xml["token"].element?.text else {
                return promise.error(with: .noData)
            }
            promise.success(with: token)
        }
    }
    
    func confirm(token: String) -> Response<Bool> {
        return doRepresentedRequest(to: .tokenConfirmation).nested { (xml: XMLIndexer) in
            return xml["confirmed"].element?.text == "true"
        }
    }
    
}
