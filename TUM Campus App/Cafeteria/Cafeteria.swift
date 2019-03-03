//
//  Cafeteria.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData
import MapKit


@objc final class Cafeteria: NSManagedObject, Entity, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /*
     {
        "mensa": "5",
        "id": "421",
        "name": "Mensa Arcisstraße",
        "address": "Arcisstr. 17, München",
        "latitude": "48.147312",
        "longitude": "11.567229"
     }
 */
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case mensa
        case name
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
        }
        let latitudeString = try container.decode(String.self, forKey: .latitude)
        guard let latitude = Double(latitudeString) else {
            throw DecodingError.typeMismatch(Double.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for latitude could not be converted to Double"))
        }
        let longitudeString = try container.decode(String.self, forKey: .longitude)
        guard let longitude = Double(longitudeString) else {
            throw DecodingError.typeMismatch(Double.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for longitude could not be converted to Double"))
        }
        let mensaString = try container.decode(String.self, forKey: .mensa)
        guard let mensa = Int64(mensaString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for mensa could not be converted to Int64"))
        }
        let name = try container.decode(String.self, forKey: .name)
        
        let menuFetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
        menuFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Menu.mensaID) , id)
        let menu = try context.fetch(menuFetchRequest)
        
        let sidesFetchRequest: NSFetchRequest<SideDish> = SideDish.fetchRequest()
        sidesFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(SideDish.mensaID) , id)
        let sides = try context.fetch(sidesFetchRequest)
        
        self.init(entity: Cafeteria.entity(), insertInto: context)
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.mensa = mensa
        self.name = name
        self.menu = NSSet(array: menu)
        self.sides = NSSet(array: sides)
    }
    
}
