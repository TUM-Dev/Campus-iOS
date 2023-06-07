//
//  TUMEvent.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import Foundation

struct TUMEvent: Codable {
    let user, title, category: String
    let date: String
    let link: String
    let body: String
}
