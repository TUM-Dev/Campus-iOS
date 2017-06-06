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
    
    let searchManagers: [TumDataItems] = [.PersonSearch, .LectureSearch, .RoomSearch]
    
    var isLoggedIn: Bool {
        return user?.token != nil
    }
    
    var user: User?
    
    lazy var managers: [TumDataItems:Manager] = [
        .Cafeterias: CafeteriaManager(mainManager: self),
        .CafeteriasCard: CafeteriaManager(mainManager: self, single: true),
        .CafeteriaMenu: CafeteriaMenuManager(mainManager: self),
        // .TuitionStatus: TuitionStatusManager(mainManager: self),
        // .TuitionStatusSingle: TuitionStatusManager(mainManager: self, single: true),
        // .MovieCard: MovieManager(single: true),
        // .MoviesCollection: MovieManager(mainManager: self),
        // .CalendarCard: CalendarManager(mainManager: self, single: true),
        // .CalendarFull: CalendarManager(mainManager: self),
//        .UserData: UserDataManager(mainManager: self),
        // .PersonSearch: PersonSearchManager(mainManager: self),
        // .LectureItems: PersonalLectureManager(mainManager: self),
        // .LectureSearch: LectureSearchManager(mainManager: self),
        // .GradeItems: PersonalGradeManager(mainManager: self),
        // .RoomSearch: RoomSearchManager(mainManager: self),
        // .RoomMap: RoomFinderMapManager(mainManager: self),
//        .PersonDetail: PersonDetailDataManager(mainManager: self),
        // .LectureDetails: LectureDetailsManager(mainManager: self),
        // .NewsCard: NewsManager(single: true),
        // .NewsCollection: NewsManager(single: false),
        // .StudyRooms: StudyRoomsManager(mainManager: self),
        // .TUMSexy : TumSexyManager(mainManager: self),
    ]
    
    func getToken() -> String {
        return user?.token ?? ""
    }
    
    init(user: User?) {
        self.user = user
        
        let config = Config(tumCabeURL: "https://tumcabe.in.tum.de/Api/",
                            tumOnlineURL: "https://campus.tum.de/tumonline",
                            tumSexyURL: "http://json.tum.sexy",
                            roomsURL: "http://www.devapp.it.tum.de/iris/",
                            rentalsURL: "",
                            user: user)
        
        PersonalLectureManager(config: config).fetch().onSuccess { lectures in
            print(lectures)
        }
        
    }
    
    func getPersonDetails(_ handler: @escaping (_ data: [DataElement]) -> (), user: UserData) {
//        if let manager = managers[.PersonDetail] as? PersonDetailDataManager {
//            manager.userQuery = user
//            manager.fetchData(handler)
//        }
    }
    
    func getLectureDetails(_ receiver: TumDataReceiver, lecture: Lecture) {
        if let manager = managers[.LectureDetails] as? LectureDetailsManager {
            manager.fetch(for: lecture).onSuccess { receiver.receiveData([$0]) }
        }
    }
    
    func getGrades(_ receiver: TumDataReceiver) {
        managers[.GradeItems]?.fetchData(receiver.receiveData)
    }
    
    func getLectures(_ receiver: TumDataReceiver) {
        managers[.LectureItems]?.fetchData(receiver.receiveData)
    }
    
    func getCalendar(_ receiver: TumDataReceiver) {
        managers[.CalendarFull]?.fetchData(receiver.receiveData)
    }
    
    func getCardItems(_ receiver: TumDataReceiver) {
        let request = BulkRequest(receiver: receiver, sorter: {
            if let item = $0 as? CardDisplayable {
                return PersistentCardOrder.value.cards.index(of: item.cardKey).?
            }
            return -1
        })
        let filter: (Manager) -> Bool = isLoggedIn ? **{ true } : { !$0.requiresLogin }
        cardItems ==> { managers[$0] } |> filter => {
            $0.fetchData() { (data) in
                request.receiveData(data)
            }
        }
    }
    
    func search(_ receiver: TumDataReceiver, query: String, searchIn managersToSearchIn: [TumDataItems]? = nil) {
        let tmpSearchManagers = managersToSearchIn != nil ? Array(Set(searchManagers).intersection(managersToSearchIn!)) : searchManagers
        let request = BulkRequest(receiver: receiver)
        tmpSearchManagers ==> { managers[$0] as? SimpleSearchManager } => { (manager: SimpleSearchManager) in
            manager.search(query: query).onSuccess(call: request.receiveData)
        }
    }
    
    func getMapsForRoom(_ receiver: TumDataReceiver, roomID: String) {
        if let mapManager = managers[.RoomMap] as? RoomFinderMapManager {
            mapManager.search(query: roomID).onSuccess(call: receiver.receiveData)
        }
    }
    
    func getCafeteriaForID(_ id: String) -> Cafeteria? {
        if let cafeteriaManager = managers[.Cafeterias] as? CafeteriaManager {
            return cafeteriaManager.getCafeteriaForID(id)
        }
        return nil
    }
    
    func getCafeterias(_ receiver: TumDataReceiver) {
        managers[.Cafeterias]?.fetchData(receiver.receiveData)
    }
    
    func getCafeteriaMenus(_ handler: @escaping (_ data: [DataElement]) -> ()) {
        managers[.CafeteriaMenu]?.fetchData(handler)
    }
    
    func getMovies(_ receiver: TumDataReceiver) {
        managers[.MoviesCollection]?.fetchData(receiver.receiveData)
    }
    
    func getTuitionStatus(_ receiver: TumDataReceiver) {
        managers[.TuitionStatus]?.fetchData(receiver.receiveData)
    }
    
    func doPersonSearch(_ handler: @escaping (_ data: [DataElement]) -> (), query: String) {
        if let manager = managers[.PersonSearch] as? PersonSearchManager {
            manager.search(query: query).onSuccess(call: handler)
        }
    }
    
    func getAllNews(_ receiver: TumDataReceiver) {
        managers[.NewsCollection]?.fetchData(receiver.receiveData)
    }
    
    func getNextUpcomingNews() -> News? {
        return nil
        // return (managers[.NewsCollection] as? NewsManager)?.getNextUpcomingNews()
    }
    
    func getAllStudyRooms(_ receiver: TumDataReceiver) {
        managers[.StudyRooms]?.fetchData(receiver.receiveData)
    }
    
    func getUserData() {
        let handler = { (data: [DataElement]) in
            if let first = data.first as? UserData {
                self.user?.getUserData(first)
            }
        }
        managers[.UserData]?.fetchData(handler)
    }
    
    func getSexyEntries(_ receiver: TumDataReceiver) {
        managers[.TUMSexy]?.fetchData(receiver.receiveData)
    }
    
    func getRentals(_ receiver: TumDataReceiver) {
        managers[.BookRental]?.fetchData(receiver.receiveData)
    }
}
