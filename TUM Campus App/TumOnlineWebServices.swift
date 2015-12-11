//
//  TumOnlineWebServices.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation

enum TUMOnlineWebServices: String {
    case BaseUrl = "https://campus.tum.de/tumonline/wbservicesbasic."
    case PersonSearch = "personenSuche"
    case TokenRequest = "requestToken"
    case TokenConfirmation = "isTokenConfirmed"
    case TokenParameter = "pToken"
    case IDParameter = "pIdentNr"
    case TuitionStatus = "studienbeitragsstatus"
    case Calendar = "kalender"
    case PersonDetails = "personenDetails"
    case Identity = "id"
    case PersonalLectures = "veranstaltungenEigene"
    case LectureSearch = "veranstaltungenSuche"
    case Home = "https://campus.tum.de/tumonline/"
}