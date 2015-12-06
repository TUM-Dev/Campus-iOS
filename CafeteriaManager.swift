//
//  CafeteriaManager.swift
//  
//
//  Created by Mathias Quintero on 12/1/15.
//
//

import Foundation
import Alamofire
import SwiftyJSON

enum CafeteriasApi: String {
    case ID = "id"
    case Name = "name"
    case Address = "address"
    case Longitude = "longitude"
    case Latitude = "latitude"
}

class CafeteriaManager: Manager {
    
    let url = "https://tumcabe.in.tum.de/Api/mensen"
    
    var cafeterias = [Cafeteria]()
    
    required init(mainManager: TumDataManager) {
        mainManager.setManager(TumDataItems.Cafeterias, manager: self)
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if cafeterias.isEmpty {
            Alamofire.request(.GET, url, parameters: ["X-DEVICE-ID":"1"], encoding: ParameterEncoding.JSON, headers: nil).responseJSON() { (response) in
                if let value = response.result.value {
                    if let cafeteriasJsonArray = JSON(value).array {
                        for item in cafeteriasJsonArray {
                            let newCafeteria = Cafeteria(id: item[CafeteriasApi.ID.rawValue].intValue, name: item[CafeteriasApi.Name.rawValue].stringValue, address: item[CafeteriasApi.Address.rawValue].stringValue, latitude: item[CafeteriasApi.Latitude.rawValue].doubleValue, longitude: item[CafeteriasApi.Longitude.rawValue].doubleValue)
                            self.cafeterias.append(newCafeteria)
                        }
                        handler(self.cafeterias)
                    }
                    
                }
            }
        } else {
            handler(cafeterias)
        }
    }
    
}
