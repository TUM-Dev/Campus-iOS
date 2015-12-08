//
//  PersonSearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import XMLParser
import SwiftyJSON

class PersonSearchManager: SearchManager {
    
    var main: TumDataManager?
    
    var query: String?
    
    func setQuery(query: String) {
        self.query = query
    }
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        let url = getURL()
        Alamofire.request(.GET, url).responseString() { (response) in
            if let value = response.result.value {
                let dataAsDictionary = XMLParser.sharedParser.decode(value)
                let json = JSON(dataAsDictionary)
                var people = [DataElement]()
                if let nameArray = json["vorname"].array, lastnameArray = json["familienname"].array, idArray = json["obfuscated_id"].array, imagesArray = json["bild_url"].array {
                    for i in 0...nameArray.count-1 {
                        if let firstname = nameArray[i].string, lastname = lastnameArray[i].string, id = idArray[i].string {
                            let image = i < imagesArray.count ? imagesArray[0].string : ""
                            let name = firstname + " " + lastname
                            let newUser = UserData(name: name, picture: image ?? "" , id: id)
                            people.append(newUser)
                        }
                    }
                }
                handler(people)
            }
        }
    }
    
    func getIDForUser(name: String) {
        
    }
    
    func getURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.PersonSearch.rawValue
        if let token = main?.getToken(), search = query {
            let url = base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token + "&pSuche=" + search
            if let value = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()) {
                return value
            }
        }
        return ""
    }
    
}