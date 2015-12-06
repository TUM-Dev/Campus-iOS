//
//  TumManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation

class TumDataManager {
    
    let cardItems = [TumDataItems.TuitionStatus, TumDataItems.Cafeterias, TumDataItems.MovieCard]
    
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
        setManager(TumDataItems.MovieCard, manager: MovieManager(single: true))
        setManager(TumDataItems.MoviesCollection, manager: MovieManager(mainManager: self))
    }
    
    func getCardItems(receiver: TumDataReceiver) {
        let request = BulkRequest(receiver: receiver)
        for item in cardItems {
            managers[item.rawValue]?.fetchData() { (data) in
                request.receiveData(data)
            }
        }
    }
}