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

enum CafeteriasApi: String {
    case ID = "id"
    case Name = "name"
    case Address = "address"
    case Longitude = "longitude"
    case Latitude = "latitude"
}

final class CafeteriaManager: NewManager {
    
    typealias DataType = Cafeteria
    
    var config: Config
    
    var requiresLogin: Bool {
        return false
    }
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Response<[Cafeteria]> {
        
        let promise = config.tumCabe.doObjectsRequest(to: .cafeteria,
                                                      maxCacheTime: .time(.aboutOneWeek)) as Response<[Cafeteria]>
        
        return promise.flatMap { (cafeterias: [Cafeteria]) in
            
            return self.config.mensaApp.doJSONRequest(to: .exported,
                                                      queries: ["mensa_id" : "all"],
                                                      maxCacheTime: .time(.aboutOneDay)).map { (json: JSON) in
                
                let menus = json["mensa_menu"].array ==> CafeteriaMenu.init(from:)
                let extras = json["mensa_beilagen"].array ==> CafeteriaMenu.init(from:)
                
                let allMenus = menus + extras
                
                allMenus.forEach { menu in
                    cafeterias.first(where: { $0.id == menu.mensaId })?.addMenu(menu)
                }
                
                return cafeterias
            }
        }
    }
    
}
