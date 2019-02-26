//
//  TicketPayment.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class TicketPayment: NSManagedObject, Entity {
    
    /*
     {
        "stripe_publishable_key": "pk_live_bjSAhBM3WFUqeNI4cJn9upDW",
        "terms": "https://www.tu-film.de/pages/view/nutzungsbedingungen",
        "minTickets": "1",
        "maxTickets": "1"
     },
 */
    
    enum CodingKeys: String, CodingKey {
        case maxTickets
        case minTickets
        case stripe_publishable_key
        case terms
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let maxTickets = try container.decode(String.self, forKey: .maxTickets)
        let minTickets = try container.decode(String.self, forKey: .minTickets)
        let stripe_publishable_key = try container.decode(String.self, forKey: .stripe_publishable_key)
        let terms = try container.decode(String.self, forKey: .terms)
        
        self.init(entity: TicketPayment.entity(), insertInto: context)
        self.maxTickets = maxTickets
        self.minTickets = minTickets
        self.stripe_publishable_key = stripe_publishable_key
        self.terms = terms
    }
    
}
