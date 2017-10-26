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
    
    func handle(_ data: String, sender: UIViewController? = nil) {
        switch self {
        case .Phone:
            if let url = URL(string: "tel://\(data)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        case .Mobile:
            if let url = URL(string: "tel://\(data)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        case .Fax: return
        case .Email:
            if let url = URL(string: "mailto://\(data)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        case .Web:
            data.url?.open(sender: sender)
            return
        }
    }
    
}
