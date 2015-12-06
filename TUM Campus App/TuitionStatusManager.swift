//
//  TuitionStatusManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import XMLParser
import SwiftyJSON

class TuitionStatusManager: Manager {
    
    var main: TumDataManager?
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        let url = getURL()
        var tuitionItems = [DataElement]()
        Alamofire.request(.GET, url).responseString() { (response) in
            if let data = response.result.value {
                let dataAsDictionary = XMLParser.sharedParser.decode(data)
                let json = JSON(dataAsDictionary)
                if let sollArray = json["soll"].array, fristArray = json["frist"].array, bezArray = json["semester_bezeichnung"].array {
                    for i in 0...((sollArray.count)-1) {
                        if let soll = sollArray[i].string, frist = fristArray[i].string, bez = bezArray[i].string {
                            let tuition = Tuition(frist: frist, semester: bez, soll: soll)
                            tuitionItems.append(tuition)
                        }
                    }
                    handler(tuitionItems)
                }
            }
        }
    }
    
    func getURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.TuitionStatus.rawValue
        if let token = main?.getToken() {
            return base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token
        }
        return ""
    }
}