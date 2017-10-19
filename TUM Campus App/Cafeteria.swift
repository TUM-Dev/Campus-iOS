//
//  Cafeteria.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import CoreLocation

class Cafeteria: DataElement {
    
    let address: String
    let id: Int
    let name: String
    var menus = [String : [CafeteriaMenu]]()
    let location: CLLocation

    init(id: Int, name: String, address: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func addMenu(_ menu: CafeteriaMenu) {
        let key = menu.date.string(using: "yyyy MM dd")
        menus[key, default: []].append(menu)
        menus[key] = menus[key]?.sorted(ascending: \.typeNr)
    }
    
    func getMenusForDate(_ date: Date) -> [CafeteriaMenu] {
        return menus[date.string(using: "yyyy MM dd")] ?? []
    }
    
    func distance(_ from: CLLocation) -> CLLocationDistance {
        return from.distance(from: location)
    }
    
    func getCellIdentifier() -> String {
        return "cafeteria"
    }
    
    var text: String {
        return name
    }
    
}

extension Cafeteria {
    
    convenience init?(from json: JSON) {
        
        
        
        let newCafeteria = Cafeteria(id: item[CafeteriasApi.ID.rawValue].intValue, name: item[CafeteriasApi.Name.rawValue].stringValue, address: item[CafeteriasApi.Address.rawValue].stringValue, latitude: item[CafeteriasApi.Latitude.rawValue].doubleValue, longitude: item[CafeteriasApi.Longitude.rawValue].doubleValue)
    }
    
}

extension Cafeteria: CardDisplayable {
    
    var cardKey: CardKey {
        return  .cafeteria
    }
    
}
