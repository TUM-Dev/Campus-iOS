//
//  TumManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation

class TumDataManager {
    
    let cardItems = [TumDataItems.TuitionStatusSingle, TumDataItems.MovieCard, TumDataItems.CalendarCard, TumDataItems.CafeteriaMenu]
    
    let searchManagers = [TumDataItems.PersonSearch]
    
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
        setManager(TumDataItems.Cafeterias, manager: CafeteriaManager(mainManager: self))
        setManager(TumDataItems.TuitionStatus, manager: TuitionStatusManager(mainManager: self))
        setManager(TumDataItems.TuitionStatusSingle, manager: TuitionStatusManager(mainManager: self, single: true))
        setManager(TumDataItems.MovieCard, manager: MovieManager(single: true))
        setManager(TumDataItems.MoviesCollection, manager: MovieManager(mainManager: self))
        setManager(TumDataItems.CalendarCard, manager: CalendarManager(mainManager: self, single: true))
        setManager(TumDataItems.CalendarFull, manager: CalendarManager(mainManager: self))
        setManager(TumDataItems.CafeteriaMenu, manager: CafeteriaMenuManager(mainManager: self))
        setManager(TumDataItems.UserData, manager: UserDataManager(mainManager: self))
        setManager(TumDataItems.PersonSearch, manager: PersonSearchManager(mainManager: self))
        managers[TumDataItems.Cafeterias.rawValue]?.fetchData() { (data) in }
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
    
    func getCafeteriaForID(id: String) -> Cafeteria? {
        if let cafeteriaManager = managers[TumDataItems.Cafeterias.rawValue] as? CafeteriaManager {
            return cafeteriaManager.getCafeteriaForID(id)
        }
        return nil
    }
    
    func getCafeterias(receiver: TumDataReceiver) {
        managers[TumDataItems.Cafeterias.rawValue]?.fetchData(receiver.receiveData)
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
    
    func getUserData() {
        let handler = { (data: [DataElement]) in
            if let first = data.first as? UserData {
                self.user?.getUserData(first)
            }
        }
        managers[TumDataItems.UserData.rawValue]?.fetchData(handler)
    }
    
}