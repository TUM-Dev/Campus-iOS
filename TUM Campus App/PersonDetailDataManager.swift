//
//  PersonDetailDataManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/23/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import SWXMLHash
import Sweeft

final class PersonDetailDataManager: DetailsManager {
    
    typealias DataType = UserData
    
    var config: Config
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch(for data: UserData) -> Promise<UserData, APIError> {
        guard !data.contactsLoaded else {
            return .successful(with: data)
        }
        return config.tumOnline.doRepresentedRequest(to: .personDetails,
                                                     queries: ["pIdentNr": data.id]).map { (xml: XMLIndexer) in
            
            let dien = xml["person"]["dienstlich"]
            let privat = xml["person"]["privat"]
            var contactInfo = [(ContactInfoType,String?)]()
            contactInfo.append((.Email, xml["person"]["email"].element?.text))
            contactInfo.append((.Phone, dien["telefon"].element?.text))
            contactInfo.append((.Phone, privat["telefon"].element?.text))
            let phones = xml["person"]["telefon_nebenstellen"]["nebenstelle"].all
            for phone in phones {
                contactInfo.append((.Phone, phone["telefonnummer"].element?.text))
            }
            contactInfo.append((.Mobile, dien["mobiltelefon"].element?.text))
            contactInfo.append((.Mobile, privat["mobiltelefon"].element?.text))
            contactInfo.append((.Fax, dien["fax"].element?.text))
            contactInfo.append((.Fax, privat["fax"].element?.text))
            contactInfo.append((.Web, dien["www_homepage"].element?.text))
            contactInfo.append((.Web, privat["www_homepage"].element?.text))
            
            for item in contactInfo {
                if let infoValue = item.1, infoValue != "" {
                    data.contactInfo.append((item.0, infoValue))
                }
            }
            
            return data
        }
    }
    
}
