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
    lazy var bookRentalManager: NewBookRentalManager = { NewBookRentalManager(config: self.config) }()
    lazy var studyRoomsManager: StudyRoomsManager = { StudyRoomsManager(config: self.config) }()
    lazy var lecturesManager: PersonalLectureManager = { PersonalLectureManager(config: self.config) }()
    lazy var gradesManager: PersonalGradeManager = { PersonalGradeManager(config: self.config) }()
    lazy var tumSexyManager: TumSexyManager = { TumSexyManager(config: self.config) }()
    lazy var cafeteriaManager: CafeteriaManager = { CafeteriaManager(config: self.config) }()
    lazy var mvgManager: MVGManager = { MVGManager(config: self.config) }()
    
    lazy var lectureDetailsManager: LectureDetailsManager = { LectureDetailsManager(config: self.config) }()
    lazy var personDetailsManager: PersonDetailDataManager = { PersonDetailDataManager(config: self.config) }()
    lazy var roomMapsManager: RoomFinderMapManager = { RoomFinderMapManager(config: self.config) }()
    
    lazy var roomSearchManager: RoomSearchManager = { RoomSearchManager(config: self.config) }()
    lazy var personSearchManager: PersonSearchManager = { PersonSearchManager(config: self.config) }()
    lazy var lectureSearchManager: LectureSearchManager = { LectureSearchManager(config: self.config) }()
    
    lazy var loginManager: TumOnlineLoginRequestManager = { TumOnlineLoginRequestManager(config: self.config) }()
    
    var isLoggedIn: Bool {
        return user?.token != nil
    }
    
    private(set) var config: Config
    var user: User? {
        return config.tumOnline.user
    }
    
    var cardManager: [CardManager] {
        return [
            calendarManager,
            movieManager,
            newsManager,
            tuitionManager,
            cafeteriaManager,
        ]
    }
    
    var searchManagers: [SimpleSearchManager] {
        return [
            roomSearchManager,
            personSearchManager,
            lectureSearchManager
        ]
    }
    
    func getToken() -> String {
        return user?.token ?? ""
    }
    
    init?(user: User?, json: JSON) {
        guard let config = Config(user: user, json: json) else {
            return nil
        }
        self.config = config
    }
    
    func getCardItems() -> Response<[DataElement]> {
        // TODO: Sort
        return (self.cardManager.sorted(ascending: \.indexInOrder) => { $0.fetchSingle() }).bulk.map(completionQueue: .main) { $0.flatMap { $0 } }
    }
    
    func search(query: String) -> Response<[DataElement]> {
        // TODO: Handle more
        return (self.searchManagers => { $0.search(query: query) }).bulk.map(completionQueue: .main) { $0.flatMap { $0 } }
    }
    
}
