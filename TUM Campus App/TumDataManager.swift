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
    
    lazy var managers: [TumDataItems:Manager] = [
        .Cafeterias: CafeteriaManager(mainManager: self),
        .CafeteriasCard: CafeteriaManager(mainManager: self, single: true),
        .CafeteriaMenu: CafeteriaMenuManager(mainManager: self),
        .TuitionStatus: TuitionStatusManager(mainManager: self),
        .TuitionStatusSingle: TuitionStatusManager(mainManager: self, single: true),
        .MovieCard: MovieManager(single: true),
        .MoviesCollection: MovieManager(mainManager: self),
        .CalendarCard: CalendarManager(mainManager: self, single: true),
        .CalendarFull: CalendarManager(mainManager: self),
        .UserData: UserDataManager(mainManager: self),
        .PersonSearch: PersonSearchManager(mainManager: self),
        .LectureItems: PersonalLectureManager(mainManager: self),
        .LectureSearch: LectureSearchManager(mainManager: self),
        .RoomSearch: RoomSearchManager(mainManager: self),
        .RoomMap: RoomFinderMapManager(mainManager: self),
        .PersonDetail: PersonDetailDataManager(mainManager: self),
        .LectureDetails: LectureDetailsManager(mainManager: self),
        .NewsCard: NewsManager(single: true),
        .NewsCollection: NewsManager(single: false),
    ]
    
    func getToken() -> String {
        return user?.token ?? ""
    }
    
    init(user: User?) {
        self.user = user
    }
    
    func getPersonDetails(handler: (data: [DataElement]) -> (), user: UserData) {
        if let manager = managers[.PersonDetail] as? PersonDetailDataManager {
            manager.userQuery = user
            manager.fetchData(handler)
        }
    }
    
    func getLectureDetails(receiver: TumDataReceiver, lecture: Lecture) {
        if let manager = managers[.LectureDetails] as? LectureDetailsManager {
            manager.query = lecture
            manager.fetchData(receiver.receiveData)
        }
    }
    
    func getLectures(receiver: TumDataReceiver) {
        managers[.LectureItems]?.fetchData(receiver.receiveData)
    }
    
    func getCalendar(receiver: TumDataReceiver) {
        managers[.CalendarFull]?.fetchData(receiver.receiveData)
    }
    
    func getCardItems(receiver: TumDataReceiver) {
        let request = BulkRequest(receiver: receiver)
        for item in cardItems {
            managers[item]?.fetchData() { (data) in
                request.receiveData(data)
            }
        }
    }
    
    func search(receiver: TumDataReceiver, query: String) {
        let request = BulkRequest(receiver: receiver)
        for item in searchManagers {
            if let manager = managers[item] as? SearchManager {
                manager.setQuery(query)
                manager.fetchData() { (data) in
                    request.receiveData(data)
                }
            }
        }
    }
    
    func getMapsForRoom(receiver: TumDataReceiver, roomID: String) {
        if let mapManager = managers[.RoomMap] as? RoomFinderMapManager {
            mapManager.setQuery(roomID)
            mapManager.fetchData(receiver.receiveData)
        }
    }
    
    func getCafeteriaForID(id: String) -> Cafeteria? {
        if let cafeteriaManager = managers[.Cafeterias] as? CafeteriaManager {
            return cafeteriaManager.getCafeteriaForID(id)
        }
        return nil
    }
    
    func getCafeterias(receiver: TumDataReceiver) {
        managers[.Cafeterias]?.fetchData(receiver.receiveData)
    }
    
    func getCafeteriaMenus(handler: (data: [DataElement]) -> ()) {
        managers[.CafeteriaMenu]?.fetchData(handler)
    }
    
    func getMovies(receiver: TumDataReceiver) {
        managers[.MoviesCollection]?.fetchData(receiver.receiveData)
    }
    
    func getTuitionStatus(receiver: TumDataReceiver) {
        managers[.TuitionStatus]?.fetchData(receiver.receiveData)
    }
    
    func doPersonSearch(handler: (data: [DataElement]) -> (), query: String) {
        if let manager = managers[.PersonSearch] as? PersonSearchManager {
            manager.query = query
            manager.fetchData(handler)
        }
    }
    
    func getAllNews(receiver: TumDataReceiver) {
        managers[.NewsCollection]?.fetchData(receiver.receiveData)
    }
    
    func getUserData() {
        let handler = { (data: [DataElement]) in
            if let first = data.first as? UserData {
                self.user?.getUserData(first)
            }
        }
        managers[.UserData]?.fetchData(handler)
    }
    
}