//
//  EmptyCard.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation

class EmptyCard: DataElement {
    
    var text: String {
        return "You have no cards in your view!"
    }
    
    func getCellIdentifier() -> String {
        return "empty"
    }
    
}
