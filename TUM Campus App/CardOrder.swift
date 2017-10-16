//
//  CardOrder.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Sweeft

struct CardOrder: Codable {
    var cards: [CardKey]
    
    var managers: [TumDataItems] {
        return cards ==> { CardKey.managers | $0 }
    }
    
    mutating func remove(cardFor data: DataElement) {
        cards <| { $0 != (data as? CardDisplayable)?.cardKey }
    }
    
}

struct PersistentCardOrder: SingleStatus {
    static var key: AppDefaults = .cards
    static var defaultValue = CardOrder(cards: CardKey.all)
}
