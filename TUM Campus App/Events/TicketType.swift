//
//  TicketType.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class TicketType: NSManagedObject, Entity {
    
    /*
     {
        "ticket_type": "26",
        "event": "8",
        "ticket_payment": "1",
        "price": "320",
        "contingent": "50",
        "description": "VVK+Buchungspauschale",
        "payment": {
            "stripe_publishable_key": "pk_live_bjSAhBM3WFUqeNI4cJn9upDW",
            "terms": "https://www.tu-film.de/pages/view/nutzungsbedingungen",
            "minTickets": "1",
            "maxTickets": "1"
            },
        "sold": "4"
        }
 */
    
    enum CodingKeys: String, CodingKey {
        case contingent = "contingent"
        case event = "event"
        case price = "price"
        case sold = "sold"
        case ticket_description = "description"
        case ticket_payment = "ticket_payment"
        case payment = "payment"
        case ticket_type = "ticket_type"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let contingent = try container.decode(String.self, forKey: .contingent)
        let eventString = try container.decode(String.self, forKey: .event)
        guard let event = Int64(eventString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for event could not be converted to Int64"))
        }
        let price = try container.decode(String.self, forKey: .price)
        let sold = try container.decode(String.self, forKey: .sold)
        let ticket_description = try container.decode(String.self, forKey: .ticket_description)
        let ticket_payment = try container.decode(String.self, forKey: .ticket_payment)
        let payment = try container.decode(TicketPayment.self, forKey: .payment)
        let ticket_type = try container.decode(String.self, forKey: .ticket_type)
        
        let eventFetchRequest: NSFetchRequest<TicketEvent> = TicketEvent.fetchRequest()
        eventFetchRequest.predicate = NSPredicate(format: "\(TicketEvent.CodingKeys.event.rawValue) == %d", event)
        let event_ticket = try context.fetch(eventFetchRequest).first
        
        self.init(entity: TicketType.entity(), insertInto: context)
        self.contingent = contingent
        self.event = event
        self.price = price
        self.sold = sold
        self.ticket_description = ticket_description
        self.ticket_type = ticket_type
        self.ticket_payment = ticket_payment
        self.payment = payment
        self.event_ticket = event_ticket
    }
    
}


