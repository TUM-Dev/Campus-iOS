//
//  TumManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft

class TumDataManager {
    
    lazy var calendarManager: CalendarManager = { CalendarManager(config: self.config) }()
    lazy var movieManager: MovieManager = { MovieManager(config: self.config) }()
    lazy var newsManager: NewsManager = { NewsManager(config: self.config) }()
    lazy var tuitionManager: TuitionStatusManager = { TuitionStatusManager(config: self.config) }()
    lazy var bookRentalManager: BookRentalManager = { BookRentalManager(config: self.config) }()
    lazy var studyRoomsManager: StudyRoomsManager = { StudyRoomsManager(config: self.config) }()
    lazy var lecturesManager: PersonalLectureManager = { PersonalLectureManager(config: self.config) }()
    lazy var gradesManager: PersonalGradeManager = { PersonalGradeManager(config: self.config) }()
    lazy var tumSexyManager: TumSexyManager = { TumSexyManager(config: self.config) }()
    lazy var cafeteriaManager: CafeteriaManager = { CafeteriaManager(config: self.config) }()
    lazy var mvgManager: MVGManager = { MVGManager(config: self.config) }()
    
    lazy var tuFilmNewsManager: TUFilmNewsManager = { TUFilmNewsManager(newsManager: self.newsManager) }()
    lazy var tumNewsManager: TUMNewsManager = { TUMNewsManager(newsManager: self.newsManager) }()
    lazy var newsSpreadManager: NewsSpreadManager = { NewsSpreadManager(newsManager: self.newsManager) }()
    
    lazy var lectureDetailsManager: LectureDetailsManager = { LectureDetailsManager(config: self.config) }()
    lazy var personDetailsManager: PersonDetailDataManager = { PersonDetailDataManager(config: self.config) }()
    lazy var roomMapsManager: RoomFinderMapManager = { RoomFinderMapManager(config: self.config) }()
    
    lazy var roomSearchManager: RoomSearchManager = { RoomSearchManager(config: self.config) }()
    lazy var personSearchManager: PersonSearchManager = { PersonSearchManager(config: self.config) }()
    lazy var lectureSearchManager: LectureSearchManager = { LectureSearchManager(config: self.config) }()
    lazy var userDataManager: UserDataManager = { UserDataManager(config: self.config) }()
    
    lazy var loginManager: TumOnlineLoginRequestManager = { TumOnlineLoginRequestManager(config: self.config) }()
    
    var isLoggedIn: Bool {
        return user?.token != nil
    }
    
    private(set) var config: Config
    var user: User? {
        return config.tumOnline.user
    }
    
    var cardManagers: [CardManager] {
        let order = PersistentCardOrder.value.cards
        return [
            calendarManager,
            movieManager,
            tumNewsManager,
            tuFilmNewsManager,
            tuitionManager,
            cafeteriaManager,
            bookRentalManager,
        ].filter({ order.contains($0.cardKey) }).sorted(ascending: \.indexInOrder)
    }
    
    var searchManagers: [SimpleSearchManager] {
        return [
            roomSearchManager,
            personSearchManager,
            lectureSearchManager,
            tumSexyManager,
        ]
    }
    
    init?(user: User?, json: JSON) {
        guard let config = Config(user: user, json: json) else {
            return nil
        }
        self.config = config
    }
    
    func loadCards(skipCache: Bool = false) -> Response<[DataElement]> {
        let promises = cardManagers => { $0.fetchCard(skipCache: skipCache) }
        return promises.bulk.map { $0.flatMap { $0 } }
    }
    
    func search(query: String) -> Response<[SearchResults]> {
        let promises: [Response<SearchResults>] = searchManagers => { $0.search(query: query) }
        return promises.bulk
    }
    
}
