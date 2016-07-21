//
//  TumManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation

class TumDataManager {
    
    let cardItems: [TumDataItems] = [.TuitionStatusSingle, .MovieCard, .CalendarCard, .CafeteriasCard, .NewsCard]
    
    let searchManagers: [TumDataItems] = [.PersonSearch, .LectureSearch, .RoomSearch]
    
    var user: User?
    
    var managers = [String:Manager]()
    
    func setManager(item: TumDataItems, manager: Manager) {
        managers[item.rawValue] = manager
    }
    
    func getToken() -> String {
        return user?.token ?? ""
    }
    
    init(user: User?) {
        self.user = user
        setManager(.Cafeterias, manager: CafeteriaManager(mainManager: self))
        setManager(.CafeteriasCard, manager: CafeteriaManager(mainManager: self, single: true))
        setManager(.CafeteriaMenu, manager: CafeteriaMenuManager(mainManager: self))
        setManager(.TuitionStatus, manager: TuitionStatusManager(mainManager: self))
        setManager(.TuitionStatusSingle, manager: TuitionStatusManager(mainManager: self, single: true))
        setManager(.MovieCard, manager: MovieManager(single: true))
        setManager(.MoviesCollection, manager: MovieManager(mainManager: self))
        setManager(.CalendarCard, manager: CalendarManager(mainManager: self, single: true))
        setManager(.CalendarFull, manager: CalendarManager(mainManager: self))
        setManager(.CafeteriaMenu, manager: CafeteriaMenuManager(mainManager: self))
        setManager(.UserData, manager: UserDataManager(mainManager: self))
        setManager(.PersonSearch, manager: PersonSearchManager(mainManager: self))
        setManager(.LectureItems, manager: PersonalLectureManager(mainManager: self))
        setManager(.LectureSearch, manager: LectureSearchManager(mainManager: self))
        setManager(.RoomSearch, manager: RoomSearchManager(mainManager: self))
        setManager(.RoomMap, manager: RoomFinderMapManager(mainManager: self))
        setManager(.PersonDetail, manager: PersonDetailDataManager(mainManager: self))
        setManager(.LectureDetails, manager: LectureDetailsManager(mainManager: self))
        setManager(.NewsCard, manager: NewsManager(single: true))
        setManager(.NewsCollection, manager: NewsManager(single: false))
        
    }
    
    func getPersonDetails(handler: (data: [DataElement]) -> (), user: UserData) {
        if let manager = managers[TumDataItems.PersonDetail.rawValue] as? PersonDetailDataManager {
            manager.userQuery = user
            manager.fetchData(handler)
        }
    }
    
    func getLectureDetails(receiver: TumDataReceiver, lecture: Lecture) {
        if let manager = managers[TumDataItems.LectureDetails.rawValue] as? LectureDetailsManager {
            manager.query = lecture
            manager.fetchData(receiver.receiveData)
        }
    }
    
    func getLectures(receiver: TumDataReceiver) {
        managers[TumDataItems.LectureItems.rawValue]?.fetchData(receiver.receiveData)
    }
    
    func getCalendar(receiver: TumDataReceiver) {
        managers[TumDataItems.CalendarFull.rawValue]?.fetchData(receiver.receiveData)
    }
    
    func getCardItems(receiver: TumDataReceiver) {
        let request = BulkRequest(receiver: receiver)
        for item in cardItems {
            managers[item.rawValue]?.fetchData() { (data) in
                request.receiveData(data)
            }
        }
    }
    
    func search(receiver: TumDataReceiver, query: String) {
        let request = BulkRequest(receiver: receiver)
        for item in searchManagers {
            if let manager = managers[item.rawValue] as? SearchManager {
                manager.setQuery(query)
                manager.fetchData() { (data) in
                    request.receiveData(data)
                }
            }
        }
    }
    
    func getMapsForRoom(receiver: TumDataReceiver, roomID: String) {
        if let mapManager = managers[TumDataItems.RoomMap.rawValue] as? RoomFinderMapManager {
            mapManager.setQuery(roomID)
            mapManager.fetchData(receiver.receiveData)
        }
    }
    
    func getCafeteriaForID(id: String) -> Cafeteria? {
        if let cafeteriaManager = managers[TumDataItems.Cafeterias.rawValue] as? CafeteriaManager {
            return cafeteriaManager.getCafeteriaForID(id)
        }
        return nil
    }
    
    func getCafeterias(receiver: TumDataReceiver) {
        managers[TumDataItems.Cafeterias.rawValue]?.fetchData(receiver.receiveData)
    }
    
    func getCafeteriaMenus(handler: (data: [DataElement]) -> ()) {
        managers[TumDataItems.CafeteriaMenu.rawValue]?.fetchData(handler)
    }
    
    func getMovies(receiver: TumDataReceiver) {
        managers[TumDataItems.MoviesCollection.rawValue]?.fetchData(receiver.receiveData)
    }
    
    func getTuitionStatus(receiver: TumDataReceiver) {
        managers[TumDataItems.TuitionStatus.rawValue]?.fetchData(receiver.receiveData)
    }
    
    func doPersonSearch(handler: (data: [DataElement]) -> (), query: String) {
        if let manager = managers[TumDataItems.PersonSearch.rawValue] as? PersonSearchManager {
            manager.query = query
            manager.fetchData(handler)
        }
    }
    
    func getAllNews(receiver: TumDataReceiver) {
        managers[TumDataItems.NewsCollection.rawValue]?.fetchData(receiver.receiveData)
    }
    
    func getUserData() {
        let handler = { (data: [DataElement]) in
            if let first = data.first as? UserData {
                self.user?.getUserData(first)
            }
        }
        managers[TumDataItems.UserData.rawValue]?.fetchData(handler)
    }
    
}