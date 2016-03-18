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
import CoreLocation

enum CafeteriasApi: String {
    case ID = "id"
    case Name = "name"
    case Address = "address"
    case Longitude = "longitude"
    case Latitude = "latitude"
}

class CafeteriaManager: Manager {
    
    var main: TumDataManager?
    
    static var locationManager = CLLocationManager()
    
    static var cafeterias = [DataElement]()
    
    var single = false
    
    static var cafeteriaMap = [String:Cafeteria]()
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    init(mainManager: TumDataManager, single: Bool) {
        main = mainManager
        self.single = single
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if CafeteriaManager.cafeterias.isEmpty {
            if let request = getRequest() {
                Alamofire.request(request).responseJSON() { (response) in
                    if let value = response.result.value {
                        if let cafeteriasJsonArray = JSON(value).array {
                            for item in cafeteriasJsonArray {
                                let newCafeteria = Cafeteria(id: item[CafeteriasApi.ID.rawValue].intValue, name: item[CafeteriasApi.Name.rawValue].stringValue, address: item[CafeteriasApi.Address.rawValue].stringValue, latitude: item[CafeteriasApi.Latitude.rawValue].doubleValue, longitude: item[CafeteriasApi.Longitude.rawValue].doubleValue)
                                CafeteriaManager.cafeterias.append(newCafeteria)
                                CafeteriaManager.cafeteriaMap[newCafeteria.id.description] = newCafeteria
                            }
                            let handle: ([DataElement]) -> () = { _ in
                                self.handle(handler)
                            }
                            self.main?.getCafeteriaMenus(handle)
                        }
                    }
                }
            }
        } else {
            handle(handler)
        }
    }
    
    func handle(handler: ([DataElement]) -> ()) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            CafeteriaManager.locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined {
            CafeteriaManager.locationManager.startUpdatingLocation()
            let location = CafeteriaManager.locationManager.location
            CafeteriaManager.locationManager.stopUpdatingLocation()
            CafeteriaManager.cafeterias.sortInPlace() { (first, second) in
                if let unwrappedLocation = location {
                    if let cafeOne = first as? Cafeteria {
                        if let cafeTwo = second as? Cafeteria {
                            return cafeOne.distance(unwrappedLocation) <= cafeTwo.distance(unwrappedLocation)
                        }
                        return true
                    }
                    return false
                }
                return false
            }
        }
        if single {
            handler([CafeteriaManager.cafeterias[0]])
        } else {
            handler(CafeteriaManager.cafeterias)
        }
    }
    
    func getCafeteriaForID(id: String) -> Cafeteria? {
        return CafeteriaManager.cafeteriaMap[id]
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
