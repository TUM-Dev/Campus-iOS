//
//  Config.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class Config {
    let tumCabe: TUMCabeAPI
    var tumOnline: TUMOnlineAPI
    let tumSexy: TUMSexyAPI
    let rooms: StudyRoomAPI
    let bookRentals: BookRentalAPI
    let mensaApp: MensaAppAPI
    let mvg: MVGAPI
    let tumCabeHomepage: URL
    let betaApp: URL
    
    init(tumCabeURL: String,
         tumCabeFingerprints: [String],
         tumOnlineURL: String,
         tumSexyURL: String,
         roomsURL: String,
         rentalsURL: String,
         mensaAppURL: String,
         mvgURL: String,
         mvgKey: String,
         tumCabeHomepage: URL,
         betaApp: URL,
         user: User?) {
        
        tumCabe = TUMCabeAPI(baseURL: tumCabeURL, sha256Fingerprints: tumCabeFingerprints)
        tumOnline = TUMOnlineAPI(baseURL: tumOnlineURL, user: user)
        tumSexy = TUMSexyAPI(baseURL: tumSexyURL)
        rooms = StudyRoomAPI(baseURL: roomsURL)
        bookRentals = BookRentalAPI(baseURL: rentalsURL)
        mensaApp = MensaAppAPI(baseURL: mensaAppURL)
        mvg = MVGAPI(baseURL: mvgURL, apiKey: mvgKey)
        self.tumCabeHomepage = tumCabeHomepage
        self.betaApp = betaApp
    }
}

extension Config {
    
    var user: User? {
        return tumOnline.user
    }
    
}

extension Config {
    
    convenience init?(user: User?, json: JSON) {
        
        guard let tumCabe = json["tumCabe"].string,
            let tumOnline = json["tumOnline"].string,
            let tumSexy = json["tumSexy"].string,
            let rooms = json["studyRooms"].string,
            let rentals = json["bookRentals"].string,
            let mensaApp = json["mensaApp"].string,
            let mvg = json["mvg"].string,
            let mvgKey = json["mvgKey"].string,
            let tumCabeHomepage = json["tumCabeHomepage"].url,
            let betaApp = json["betaApp"].url else {
                
            return nil
        }
        self.init(tumCabeURL: tumCabe,
                  tumCabeFingerprints: json["tumCabeFingerprints"].strings,
                  tumOnlineURL: tumOnline,
                  tumSexyURL: tumSexy,
                  roomsURL: rooms,
                  rentalsURL: rentals,
                  mensaAppURL: mensaApp,
                  mvgURL: mvg,
                  mvgKey: mvgKey,
                  tumCabeHomepage: tumCabeHomepage,
                  betaApp: betaApp,
                  user: user)
    }
    
}

extension Config {
    
    func clearCache() {
        tumCabe.clearCache()
        tumOnline.clearCache()
        tumSexy.clearCache()
        rooms.clearCache()
        mensaApp.clearCache()
        mvg.clearCache()
        Data.cache.clear()
    }
    
}
