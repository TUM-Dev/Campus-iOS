//
//  Config.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation

struct Config {
    let tumCabe: TUMCabeAPI
    let tumOnline: TUMOnlineAPI
    let tumSexy: TUMSexyAPI
    let rooms: StudyRoomAPI
}

extension Config {
    
    init(tumCabeURL: String, tumOnlineURL: String, tumSexyURL: String, roomsURL: String, user: User?) {
        
        self.init(tumCabe: TUMCabeAPI(baseURL: tumCabeURL),
                  tumOnline: TUMOnlineAPI(baseURL: tumOnlineURL, user: user),
                  tumSexy: TUMSexyAPI(baseURL: tumSexyURL),
                  rooms: StudyRoomAPI(baseURL: roomsURL))
    }
    
}
