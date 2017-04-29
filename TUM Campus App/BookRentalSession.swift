//
//  BookRentalSession.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/20/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation

struct BookRentalAPISession {
    let startDate: Date
    let endDate: Date
}

extension BookRentalAPISession {
    
    init() {
        self.init(startDate: .now, endDate: Date.now.addingTimeInterval(20 * 60))
    }
    
}
