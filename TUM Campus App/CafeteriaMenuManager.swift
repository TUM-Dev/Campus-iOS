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
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if CafeteriaMenuManager.cafeteriaMenus.isEmpty {
            if let request = getRequest() {
                Alamofire.request(request as! URLRequestConvertible).responseJSON() { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let cafeteriasJsonArray = json["mensa_menu"].array {
                            for item in cafeteriasJsonArray {
                                self.addMenu(item)
                            }
                            if let beilagenJsonArray = json["mensa_beilagen"].array {
                                for item in beilagenJsonArray {
                                    self.addMenu(item)
                                }
                            }
                            handler(CafeteriaMenuManager.cafeteriaMenus)
                        }
                    }
                }
            }
        }
    }
    
    func addMenu(_ item: JSON) {
        if let cafeteria = item["mensa_id"].string, let date = item["date"].string, let typeShort = item["type_short"].string, let typeLong = item["type_long"].string, let name = item["name"].string, let mensa = self.manager?.getCafeteriaForID(cafeteria) {
            let id = item["id"].string ?? ""
            let typeNR = item["type_nr"].string ?? ""
            let idNumber = Int(id) ?? 0
            let nr = Int(typeNR) ?? Int.max
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            let dateAsDate = dateformatter.date(from: date) ?? Date()
            let newMenu = CafeteriaMenu(id: idNumber, date: dateAsDate, typeShort: typeShort, typeLong: typeLong, typeNr: nr, name: name)
            mensa.addMenu(newMenu)
            CafeteriaMenuManager.cafeteriaMenus.append(newMenu)
        }
    }
    
    func getURL() -> String {
        return "http://lu32kap.typo3.lrz.de/mensaapp/exportDB.php?mensa_id=all"
    }
    
    func getRequest() -> NSMutableURLRequest? {
        if let url = URL(string: getURL()), let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(uuid, forHTTPHeaderField: "X-DEVICE-ID")
            return request
        }
        return nil
    }
    
    
}
