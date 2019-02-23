//
//  LectureTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import XMLParsing
import Alamofire

class LecturesTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Lecture, Lectures, XMLDecoder>
    var endpoint: URLRequestConvertible = TUMOnlineAPI.personalLectures
    lazy var importer = ImporterType(context: context, endpoint: endpoint, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    lazy var context: NSManagedObjectContext = {
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Lecture> = {
        let fetchRequest: NSFetchRequest<Lecture> = Lecture.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "semester_id", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importer.performFetch()
        try! fetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! fetchedResultsController.performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureCell", for: indexPath)
        let lecture = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = lecture.stp_sp_title
        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
