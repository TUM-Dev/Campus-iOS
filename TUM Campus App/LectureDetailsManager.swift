//
//  LectureDetailsManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 1/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class LectureDetailsManager: Manager {
    
    
    var main: TumDataManager?
    
    var request: Request?
    
    var query: Lecture?
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        request?.cancel()
        if let data = query {
            if !data.detailsLoaded {
                let url = getURL()
                request = Alamofire.request(url).responseString() { (response) in
                    if let value = response.result.value {
                        let parsedXML = SWXMLHash.parse(value)
                        let result = parsedXML["rowset"]["row"].all.first
                        if let lecture = result {
                            self.query?.detailsLoaded = true
                            var details = [(String,String?)]()
                            details.append(("Methods",lecture["lehrmethode"].element?.text))
                            details.append(("Content",lecture["lehrinhalt"].element?.text))
                            details.append(("Goal",lecture["lehrziel"].element?.text))
                            details.append(("Language",lecture["haupt_unterrichtssprache"].element?.text))
                            details.append(("First Appointment",lecture["ersttermin"].element?.text))
                            for detail in details {
                                if let info = detail.1 {
                                    self.query?.details.append(detail.0,info)
                                }
                            }
                        }
                        handler([])
                    }
                }
            }
        }
    }
    
    func getURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.LectureDetails.rawValue
        if let token = main?.getToken(), let id = query?.id {
            return base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token + "&" + TUMOnlineWebServices.LectureIDParameter.rawValue + "=" + id
        }
        return ""
    }

    
}
