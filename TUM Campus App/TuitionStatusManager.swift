//
//  TuitionStatusManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SWXMLHash

class TuitionStatusManager: Manager {
    
    var main: TumDataManager?
    
    var single = false
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    init(mainManager: TumDataManager, single: Bool) {
        main = mainManager
        self.single = single
    }
    
    static var tuitionItems = [DataElement]()
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if TuitionStatusManager.tuitionItems.isEmpty {
            let url = getURL()
            Alamofire.request(url).responseString() { (response) in
                if let data = response.result.value {
                    let tuitionData = SWXMLHash.parse(data)
                    let rows = tuitionData["rowset"]["row"].all
                    for row in rows {
                        if let soll = row["soll"].element?.text,
                                let frist = row["frist"].element?.text,
                                let bez = row["semester_bezeichnung"].element?.text {
                            
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "yyyy-MM-dd"
                            if let fristDate = dateformatter.date(from: frist) {
                                let tuition = Tuition(frist: fristDate, semester: bez, soll: soll)
                                TuitionStatusManager.tuitionItems.append(tuition)
                            }
                            
                        }
                    }
                    self.handle(handler)
                }
            }
        } else {
            handle(handler)
        }
        
    }
    
    func handle(_ handler: ([DataElement]) -> ()) {
        if single {
            if let tuitionItem = TuitionStatusManager.tuitionItems.first {
                handler([tuitionItem])
            }
        } else {
            handler(TuitionStatusManager.tuitionItems)
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
