//
//  CafeteriaManager.swift
//  
//
//  Created by Mathias Quintero on 12/1/15.
//
//

import Foundation
import Sweeft
import CoreLocation

final class CafeteriaManager: CachedManager, SingleItemCachedManager, CardManager {
    
    typealias DataType = Cafeteria
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    var defaultMaxCache: CacheTime {
        return .time(.aboutOneDay)
    }
    
    var cardKey: CardKey {
        return .cafeteria
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func toSingle(from items: [Cafeteria]) -> DataElement? {
        return items.first(where: { $0.hasMenuToday })
    }
    
    func fetchMenus(for cafeterias: [Cafeteria], maxCache: CacheTime) -> Response<[Cafeteria]> {
        return self.config.mensaApp.doJSONRequest(to: .exported,
                                                  queries: ["mensa_id" : "all"],
                                                  maxCacheTime: maxCache).map { (json: JSON) in
                                                    
            let menus = json["mensa_menu"].array ==> CafeteriaMenu.init(from:)
            let extras = json["mensa_beilagen"].array ==> CafeteriaMenu.init(from:)
                                                    
            let allMenus = menus + extras
                                                    
            allMenus.forEach { menu in
                cafeterias.first(where: \.id, equals: menu.mensaId)?.addMenu(menu)
            }
                                                    
            return cafeterias.sorted(byLocation: \.location)
        }
    }
    
    func fetch(maxCache: CacheTime) -> Response<[Cafeteria]> {
        
        let promise = config.tumCabe.doObjectsRequest(to: .cafeteria,
                                                      maxCacheTime: maxCache) as Response<[Cafeteria]>
        
        return promise.flatMap { (cafeterias: [Cafeteria]) in
            return self.fetchMenus(for: cafeterias, maxCache: maxCache)
        }
    }
    
}
