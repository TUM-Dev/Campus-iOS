//
//  ContactInfoType.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/24/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit
enum ContactInfoType: String {
    
    case Phone = "Phone"
    case Mobile = "Mobile"
    case Email = "Mail"
    case Fax = "Fax"
    case Web = "Webpage"
    
    func handle(data: String) {
        switch self {
        case .Phone:
            if let url = NSURL(string: "tel://\(data)") {
                UIApplication.sharedApplication().openURL(url)
            }
            return
        case .Mobile:
            if let url = NSURL(string: "tel://\(data)") {
                UIApplication.sharedApplication().openURL(url)
            }
            return
        case .Fax: return
        case .Email:
            if let url = NSURL(string: "mailto://\(data)") {
                UIApplication.sharedApplication().openURL(url)
            }
            return
        case .Web:
            if let url = NSURL(string: data) {
                UIApplication.sharedApplication().openURL(url)
            }
            return
        }
    }
    
}