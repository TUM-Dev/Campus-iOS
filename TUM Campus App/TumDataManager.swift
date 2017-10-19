//
//  TumManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

class TumDataManager {
    
    var cardItems: [TumDataItems] {
        return PersistentCardOrder.value.managers
    }
    
    lazy var calendarManager: CalendarManager = { CalendarManager(config: self.config) }()
    lazy var movieManager: MovieManager = { MovieManager(config: self.config) }()
    lazy var newsManager: NewsManager = { NewsManager(config: self.config) }()
    lazy var tuitionManager: TuitionStatusManager = { TuitionStatusManager(config: self.config) }()
    lazy var bookRentalManager: NewBookRentalManager = { NewBookRentalManager(config: self.config) }()
    
    let searchManagers: [TumDataItems] = [.PersonSearch, .LectureSearch, .RoomSearch]
    
    var isLoggedIn: Bool {
        return user?.token != nil
    }
    
    var config: Config
    var user: User?
    
    lazy var managers: [TumDataItems : Manager] = [
        :
    ]
    
    var cardManager: [SimpleSingleManager] {
        return [
            calendarManager,
            movieManager,
            newsManager,
            tuitionManager,
//            bookRentalManager,
        ]
    }
    
    func getToken() -> String {
        return user?.token ?? ""
    }
    
    init(user: User?) {
        self.user = user
        self.config = Config(tumCabeURL: "https://tumcabe.in.tum.de/Api/",
                             tumOnlineURL: "https://campus.tum.de/tumonline",
                             tumSexyURL: "http://json.tum.sexy",
                             roomsURL: "http://www.devapp.it.tum.de/iris/",
                             rentalsURL: "https://opac.ub.tum.de/InfoGuideClient.tumsis",
                             user: user)
        
        PersonalLectureManager(config: config).fetch().onSuccess { lectures in
            print(lectures)
        }
        
    }
    
    func getCardItems() -> Response<[DataElement]> {
        // TODO: Sort
        return (self.cardManager => { $0.fetchSingle() }).bulk.map(completionQueue: .main) { $0.flatMap { $0 } }
    }
}
