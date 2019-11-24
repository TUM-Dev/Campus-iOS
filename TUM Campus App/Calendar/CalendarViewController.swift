//
//  CalendarViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CalendarKit
import CoreData
import Alamofire
import XMLParsing

class CalendarViewController: DayViewController, NSFetchedResultsControllerDelegate {
    typealias ImporterType = Importer<CalendarEvent,CalendarAPIResponse,XMLDecoder>
    
    let endpoint: URLRequestConvertible = TUMOnlineAPI.calendar
    let sortDescriptor = NSSortDescriptor(keyPath: \CalendarEvent.startDate, ascending: true)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    override func viewDidLoad() {
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch() { error in
            print(error)
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let calendarEvents = importer.fetchedResultsController.fetchedObjects ?? []
        var events: [Event] = []
        
        for calendarEvent in calendarEvents {
            guard let startDate = calendarEvent.startDate, let endDate = calendarEvent.endDate else { continue }
            let event = Event()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            event.startDate = startDate
            event.endDate = endDate
            event.backgroundColor = UIColor.tumBlue.withAlphaComponent(0.4)
            event.color = .tumBlue
            event.textColor = .tumBlue
            event.text = """
            \(dateFormatter.string(from: startDate))
            \(calendarEvent.title ?? "No title")
            \(calendarEvent.location ?? "")
            \(calendarEvent.status ?? "")
            """
            event.attributedText = NSMutableAttributedString()
                .normal(dateFormatter.string(from: startDate), color: .tumBlue).newLine
                .bold(calendarEvent.title ?? "No title", color: .tumBlue).newLine
                .normal(calendarEvent.location ?? "", color: .tumBlue).newLine
                .normal(calendarEvent.status ?? "", color: .tumBlue)
            
            events.append(event)
        }
        return events
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        dayView.reloadData()
    }
    
}
