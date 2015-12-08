//
//  UserData.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
class UserData: DataElement {
    
    func getCellIdentifier() -> String {
        return "person"
    }
    
    let name: String
    let picture: String
    let id: String
    init(name: String, picture: String, id: String) {
        self.name = name
        self.id = id
        self.picture = (TUMOnlineWebServices.Home.rawValue + picture).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())?.stringByReplacingOccurrencesOfString("amp;", withString: "") ?? ""
    }
    
    var text: String {
        return name
    }
    
}