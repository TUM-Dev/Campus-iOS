//
//  ContactInfoType.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
