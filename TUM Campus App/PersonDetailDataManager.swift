//
//  PersonDetailDataManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/23/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class PersonDetailDataManager: Manager {
    
    var main: TumDataManager?
    
    var request: Request?
    
    var userQuery: UserData?
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        request?.cancel()
        if let data = userQuery {
            if !data.contactsLoaded {
                let url = getURL()
                request = Alamofire.request(.GET, url).responseString() { (response) in
                    if let value = response.result.value {
                        let parsedXML = SWXMLHash.parse(value)
                        let dien = parsedXML["person"]["dienstlich"]
                        let privat = parsedXML["person"]["privat"]
                        var contactInfo = [(ContactInfoType,String?)]()
                        contactInfo.append((.Email,parsedXML["person"]["email"].element?.text))
                        contactInfo.append((.Phone,dien["telefon"].element?.text))
                        contactInfo.append((.Phone,privat["telefon"].element?.text))
                        let phones = parsedXML["person"]["telefon_nebenstellen"]["nebenstelle"].all
                        for phone in phones {
                            contactInfo.append((.Phone, phone["telefonnummer"].element?.text))
                        }
                        contactInfo.append((.Mobile,dien["mobiltelefon"].element?.text))
                        contactInfo.append((.Mobile,privat["mobiltelefon"].element?.text))
                        contactInfo.append((.Fax,dien["fax"].element?.text))
                        contactInfo.append((.Fax,privat["fax"].element?.text))
                        contactInfo.append((.Web,dien["www_homepage"].element?.text))
                        contactInfo.append((.Web,privat["www_homepage"].element?.text))
                        
                        let titel = parsedXML["person"]["titel"].element?.text
                        for data in contactInfo {
                            if let infoValue = data.1 {
                                self.userQuery?.contactInfo.append((data.0,infoValue))
                            }
                        }
                        self.userQuery?.title = titel
                        handler([])
                    }
                }
            }
        }
    }
    
    func getURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.PersonDetails.rawValue
        if let token = main?.getToken(), id = userQuery?.id {
            return base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token + "&" + TUMOnlineWebServices.IDParameter.rawValue + "=" + id
        }
        return ""
    }

    
}