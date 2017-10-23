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

struct TUMOnlineAPI: API {
    
    typealias Endpoint = TUMOnlineEndpoint
    
    let baseURL: String
    var user: User?
    
    var baseQueries: [String : String] {
        guard let token = user?.token else {
            return .empty
        }
        return [
            "pToken": token
        ]
    }
    
}
