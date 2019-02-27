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
        case eventID = "event"
        case price = "price"
        case sold = "sold"
        case ticketDescription = "description"
        case paymentID = "ticket_payment"
        case payment = "payment"
        case id = "ticket_type"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let contingent = try container.decode(String.self, forKey: .contingent)
        let eventString = try container.decode(String.self, forKey: .eventID)
        guard let eventID = Int64(eventString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for event could not be converted to Int64"))
        }
        let price = try container.decode(String.self, forKey: .price)
        let sold = try container.decode(String.self, forKey: .sold)
        let ticketDescription = try container.decode(String.self, forKey: .ticketDescription)
        let paymentID = try container.decode(String.self, forKey: .paymentID)
        let payment = try container.decode(TicketPayment.self, forKey: .payment)
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for ticket_type could not be converted to Int64"))
        }
        let eventFetchRequest: NSFetchRequest<TicketEvent> = TicketEvent.fetchRequest()
        eventFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(TicketEvent.id) , eventID)
        let ticket = try context.fetch(eventFetchRequest).first
        
        self.init(entity: TicketType.entity(), insertInto: context)
        self.contingent = contingent
        self.eventID = eventID
        self.price = price
        self.sold = sold
        self.ticketDescription = ticketDescription
        self.id = id
        self.paymentID = paymentID
        self.payment = payment
        self.ticket = ticket
    }
    
}


