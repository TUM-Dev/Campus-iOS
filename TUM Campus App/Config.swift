//
//  Config.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

struct Config {
    let tumCabe: TUMCabeAPI
    var tumOnline: TUMOnlineAPI
    let tumSexy: TUMSexyAPI
    let rooms: StudyRoomAPI
    let bookRentals: BookRentalAPI
    let mensaApp: MensaAppAPI
    let mvg: MVGAPI
}

extension Config {
    
    var user: User? {
        return tumOnline.user
    }
    
    init(tumCabeURL: String,
         tumOnlineURL: String,
         tumSexyURL: String,
         roomsURL: String,
         rentalsURL: String,
         mensaAppURL: String,
         mvgURL: String,
         mvgKey: String,
         user: User?) {
        
        self.init(tumCabe: TUMCabeAPI(baseURL: tumCabeURL),
                  tumOnline: TUMOnlineAPI(baseURL: tumOnlineURL, user: user),
                  tumSexy: TUMSexyAPI(baseURL: tumSexyURL),
                  rooms: StudyRoomAPI(baseURL: roomsURL),
                  bookRentals: BookRentalAPI(baseURL: rentalsURL),
                  mensaApp: MensaAppAPI(baseURL: mensaAppURL),
                  mvg: MVGAPI(baseURL: mvgURL, apiKey: mvgKey))
    }
    
}

extension Config {
    
    init?(user: User?, json: JSON) {
        
        guard let tumCabe = json["tumCabe"].string,
            let tumOnline = json["tumOnline"].string,
            let tumSexy = json["tumSexy"].string,
            let rooms = json["studyRooms"].string,
            let rentals = json["bookRentals"].string,
            let mensaApp = json["mensaApp"].string,
            let mvg = json["mvg"].string,
            let mvgKey = json["mvgKey"].string else {
                
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
    }
    
}
