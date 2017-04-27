//
//  Cafeteria.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import CoreLocation

class Cafeteria: DataElement {
    
    let address: String
    let id: Int
    let name: String
    var menus = [String:[CafeteriaMenu]]()
    let location: CLLocation

    init(id: Int, name: String, address: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func addMenu(_ menu: CafeteriaMenu) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let string = dateformatter.string(from: menu.date as Date)
        if menus[string] != nil {
            menus[string]?.append(menu)
            menus[string]?.sort() { (first, second) in
                return first.typeNr <= second.typeNr
            }
        } else {
            menus[string] = [menu]
        }
    }
    
    func getMenusForDate(_ date: Date) -> [CafeteriaMenu] {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        return menus[dateformatter.string(from: date)] ?? []
    }
    
    func distance(_ from: CLLocation) -> CLLocationDistance {
        return from.distance(from: location)
    }
    
    func getCellIdentifier() -> String {
        return "cafeteria"
    }
    
    func getCloseCellHeight() -> CGFloat {
        return 162
    }
    
    func getOpenCellHeight() -> CGFloat {
        return 612
    }

    
    var text: String {
        return name
    }
    
}

extension Cafeteria: CardDisplayable {
    
    var cardKey: CardKey {
        return  .cafeteria
    }
    
}
