//
//  Cafeteria.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
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
    
    func addMenu(menu: CafeteriaMenu) {
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let string = dateformatter.stringFromDate(menu.date)
        if menus[string] != nil {
            menus[string]?.append(menu)
            menus[string]?.sortInPlace() { (first, second) in
                return first.typeNr <= second.typeNr
            }
        } else {
            menus[string] = [menu]
        }
    }
    
    func getMenusForDate(date: NSDate) -> [CafeteriaMenu] {
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        return menus[dateformatter.stringFromDate(date)] ?? []
    }
    
    func distance(from: CLLocation) -> CLLocationDistance {
        return from.distanceFromLocation(location)
    }
    
    func getCellIdentifier() -> String {
        return "cafeteria"
    }
    
    var text: String {
        return name
    }
    
}