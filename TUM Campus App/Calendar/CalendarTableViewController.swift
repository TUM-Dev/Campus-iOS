//
//  CalendarTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData

class CalendarTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var coreDataStack = appDelegate.persistentContainer
    var calendarImporter: CalendarImporter?
    var calendar: [Event] = []
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dtstart", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        calendarImporter = CalendarImporter(context: context)
        calendarImporter?.fetchEvents()
        try! fetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        try! fetchedResultsController.performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let news = fetchedResultsController.fetchedObjects
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = event.title
        
        return cell
    }
    
    
}
