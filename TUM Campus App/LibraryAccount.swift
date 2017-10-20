//
//  LibraryAccount.swift
//  Campus
//
//  Created by Tim Gymnich on 20.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation

class LibraryAccount: DataElement {
    
    let name: String
    let rentals: [BookRental]
    
    
    init(name: String, rentals: [BookRental]) {
        self.name = name
        self.rentals = rentals
    }
    
    func getCellIdentifier() -> String {
        return "libraryAccount"
    }
    
    var text: String {
        return name
    }
    
}
