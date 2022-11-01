//
//  Constants.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 22.12.21.
//

import Foundation

enum Constants {
    static let tokenManagementTUMOnlineUrl = URL(string: "https://campus.tum.de/tumonline/ee/ui/ca2/app/desktop/#/pl/ui/$ctx/wbservicesadmin.userTokenManagement?$ctx=")!
    
    enum CoreDataEntity: String {
        case Grade
    }
}
