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
}

struct PersistentCardOrder: SingleStatus {
    static var key: AppDefaults = .cards
    static var defaultValue = CardOrder(cards: CardKey.all)
}
