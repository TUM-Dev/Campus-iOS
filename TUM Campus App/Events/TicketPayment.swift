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
        case maxTickets = "maxTickets"
        case minTickets = "minTickets"
        case stripeKey = "stripe_publishable_key"
        case terms = "terms"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let maxTicketsString = try container.decode(String.self, forKey: .maxTickets)
        guard let maxTickets = Int64(maxTicketsString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for maxTickets could not be converted to Int64"))
        }
        let minTicketsString = try container.decode(String.self, forKey: .minTickets)
        guard let minTickets = Int64(minTicketsString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for minTickets could not be converted to Int64"))
        }
        let stripeKey = try container.decode(String.self, forKey: .stripeKey)
        let termsString = try container.decode(String.self, forKey: .terms)
        guard let terms = URL(string: termsString.replacingOccurrences(of: " ", with: "%20")) else {
            throw DecodingError.typeMismatch(URL.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for terns could not be converted to URL"))
        }
        
        self.init(entity: TicketPayment.entity(), insertInto: context)
        self.maxTickets = maxTickets
        self.minTickets = minTickets
        self.stripeKey = stripeKey
        self.terms = terms
    }
    
}
