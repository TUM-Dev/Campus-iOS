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
    
    var cafeterias = [DataElement]()
    
    var cafeteriaMap = [String:Cafeteria]()
    
    required init(mainManager: TumDataManager) {
        mainManager.setManager(TumDataItems.Cafeterias, manager: self)
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if cafeterias.isEmpty {
            if let request = getRequest() {
                Alamofire.request(request).responseJSON() { (response) in
                    if let value = response.result.value {
                        if let cafeteriasJsonArray = JSON(value).array {
                            for item in cafeteriasJsonArray {
                                let newCafeteria = Cafeteria(id: item[CafeteriasApi.ID.rawValue].intValue, name: item[CafeteriasApi.Name.rawValue].stringValue, address: item[CafeteriasApi.Address.rawValue].stringValue, latitude: item[CafeteriasApi.Latitude.rawValue].doubleValue, longitude: item[CafeteriasApi.Longitude.rawValue].doubleValue)
                                self.cafeterias.append(newCafeteria)
                                self.cafeteriaMap[newCafeteria.id.description] = newCafeteria
                            }
                            handler(self.cafeterias)
                        }
                    }
                }
            }
        } else {
            handler(cafeterias)
        }
    }
    
    func getCafeteriaForID(id: String) -> Cafeteria? {
        return cafeteriaMap[id]
    }
    
    func getRequest() -> NSMutableURLRequest? {
        if let url = NSURL(string: getURL()), let uuid = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.setValue(uuid, forHTTPHeaderField: "X-DEVICE-ID")
            return request
        }
        return nil
    }
    
    func getURL() -> String {
        return TumCabeApi.BaseURL.rawValue + TumCabeApi.Cafeteria.rawValue
    }
    
}
