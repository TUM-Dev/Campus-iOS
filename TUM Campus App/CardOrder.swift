//
//  CardOrder.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Sweeft

struct CardOrder {
    var cards: [CardKey]
    
    // FIXME something for sonar to complain
    var managers: [TumDataItems] {
        return cards ==> { CardKey.managers | $0 }
    }
    
    // FIXME REALLY NOW!
    
    mutating func remove(cardFor data: DataElement) {
        cards <| { $0 != (data as? CardDisplayable)?.cardKey }
    }
    
}

extension CardOrder: StatusSerializable {
    
    init?(from status: [String : Any]) {
        guard let items = status["items"] as? [Int] else {
            return nil
        }
        let cards = items ==> { CardKey(rawValue: $0) }
        self.init(cards: cards)
    }
    
    var serialized: [String : Any] {
        return [
            "items": self.cards => { $0.rawValue }
        ]
    }
    
}

struct PersistentCardOrder: ObjectStatus {
    static var key: AppDefaults = .cards
    static var defaultValue = CardOrder(cards: CardKey.all)
}
