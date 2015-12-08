//
//  CafeteriaMenuManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class CafeteriaMenuManager: Manager {
    
    static var cafeteriaMenus = [DataElement]()
    
    var manager: TumDataManager?
    
    required init(mainManager: TumDataManager) {
        manager = mainManager
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if CafeteriaMenuManager.cafeteriaMenus.isEmpty {
            if let request = getRequest() {
                Alamofire.request(request).responseJSON() { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let cafeteriasJsonArray = json["mensa_menu"].array {
                            print(cafeteriasJsonArray)
                            for item in cafeteriasJsonArray {
                                if let id = item["id"].string, cafeteria = item["mensa_id"].string, date = item["date"].string, typeShort = item["type_short"].string, typeLong = item["type_long"].string, typeNR = item["type_nr"].string, name = item["name"].string, idNumber = Int(id), mensa = self.manager?.getCafeteriaForID(cafeteria), nr = Int(typeNR) {
                                    let dateformatter = NSDateFormatter()
                                    dateformatter.dateFormat = "yyyy-MM-dd"
                                    let dateAsDate = dateformatter.dateFromString(date) ?? NSDate()
                                    let newCafeteria = CafeteriaMenu(id: idNumber, cafeteria: mensa, date: dateAsDate, typeShort: typeShort, typeLong: typeLong, typeNr: nr, name: name)
                                    CafeteriaMenuManager.cafeteriaMenus.append(newCafeteria)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getURL() -> String {
        return "http://lu32kap.typo3.lrz.de/mensaapp/exportDB.php?mensa_id=all"
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
    
    
}