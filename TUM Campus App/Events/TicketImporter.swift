//
//  TicketImporter.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/26/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

final class TicketImporter {
    typealias DecoderType = JSONDecoder
    typealias EntityType = TicketEvent
    typealias EntityContainer = [TicketEvent]
    typealias ErrorHandler = (Error) -> Void
    typealias SuccessHandler = () -> Void
    
    var sortDescriptors: [NSSortDescriptor]
    var endpoint: URLRequestConvertible
    var predicate: NSPredicate?
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    private static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let coreDataStack: NSPersistentContainer = appDelegate.persistentContainer
    
    let sessionManager: Session = Session.defaultSession
    
    lazy var fetchedResultsController: NSFetchedResultsController<EntityType> = {
        let fetchRequest: NSFetchRequest<EntityType> = EntityType.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = fetchedResultsControllerDelegate
        
        return fetchedResultsController
    }()
    
    lazy var context: NSManagedObjectContext = {
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()
    
    required init(endpoint: URLRequestConvertible, sortDescriptor: NSSortDescriptor..., predicate: NSPredicate? = nil, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) {
        self.endpoint = endpoint
        self.predicate = predicate
        self.sortDescriptors = sortDescriptor
        self.dateDecodingStrategy = dateDecodingStrategy
    }
    
    func performFetch() {
        sessionManager.request(endpoint)
            .validate(statusCode: 200..<300)
            .validate(contentType: JSONDecoder.contentType)
            .responseData { [weak self] response in
                guard response.error == nil else { return }
                guard let self = self else { return }
                guard let data = response.data else { return }
                let decoder = DecoderType.instantiate()
                decoder.userInfo[.context] = self.context
                if let strategy = self.dateDecodingStrategy {
                    decoder.dateDecodingStrategy = strategy
                }
                let events = try! decoder.decode(EntityContainer.self, from: data)
                try! self.context.save()
                
                self.fetchTickets(for: events)
        }
    }
    
    func fetchTickets(for events: [TicketEvent]) {
        let eventFetchRequest: NSFetchRequest<TicketEvent> = TicketEvent.fetchRequest()
        let events = (try? context.fetch(eventFetchRequest)) ?? []
        for event in events where event.ticketType == nil {
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            sessionManager.request(TUMCabeAPI.ticketTypes(event: Int(event.id)))
                .validate(statusCode: 200..<300)
                .validate(contentType: JSONDecoder.contentType)
                .responseData { [weak self] response in
                    guard response.error == nil else { return }
                    guard let self = self else { return }
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    decoder.userInfo[.context] = self.context
                    _ = try! decoder.decode([TicketType].self, from: data)
                    try! self.context.save()
            }
            context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        }
    }
    
}
