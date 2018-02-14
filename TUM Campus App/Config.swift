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
    let betaApp: URL
    
    init(tumCabeURL: String,
         tumOnlineURL: String,
         tumSexyURL: String,
         roomsURL: String,
         rentalsURL: String,
         mensaAppURL: String,
         mvgURL: String,
         mvgKey: String,
         betaApp: URL,
         user: User?) {
        
        let fingerprints = [
            "D0 CE CA 13 E4 0A FF 49 F6 8C 2B 95 8A 66 26 89 5A 41 4F AA 47 55 F6 DC 03 7F 05 3B 5F 15 DF 1C",
            "25 84 7D 66 8E B4 F0 4F DD 40 B1 2B 6B 07 40 C5 67 DA 7D 02 43 08 EB 6C 2C 96 FE 41 D9 DE 21 8D",
            "06 87 26 03 31 A7 24 03 D9 09 F1 05 E6 9B CF 0D 32 E1 BD 24 93 FF C6 D9 20 6D 11 BC D6 77 07 39",
            ]
        
        tumCabe = TUMCabeAPI(baseURL: tumCabeURL, sha256Fingerprints: fingerprints)
        tumOnline = TUMOnlineAPI(baseURL: tumOnlineURL, user: user)
        tumSexy = TUMSexyAPI(baseURL: tumSexyURL)
        rooms = StudyRoomAPI(baseURL: roomsURL)
        bookRentals = BookRentalAPI(baseURL: rentalsURL)
        mensaApp = MensaAppAPI(baseURL: mensaAppURL)
        mvg = MVGAPI(baseURL: mvgURL, apiKey: mvgKey)
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
            let betaApp = json["betaApp"].url else {
                
            return nil
        }
        self.init(tumCabeURL: tumCabe,
                  tumOnlineURL: tumOnline,
                  tumSexyURL: tumSexy,
                  roomsURL: rooms,
                  rentalsURL: rentals,
                  mensaAppURL: mensaApp,
                  mvgURL: mvg,
                  mvgKey: mvgKey,
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
