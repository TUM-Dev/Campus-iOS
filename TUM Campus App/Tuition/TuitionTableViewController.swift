//
//  TuitionTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import XMLParsing
import CoreData
import Alamofire


class TuitionTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Tuition,TuitionFees,XMLDecoder>
    var endpoint: URLRequestConvertible = TUMOnlineAPI.tuitionStatus
    lazy var importer = ImporterType(context: context, endpoint: endpoint, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
    lazy var fetchedResultsController: NSFetchedResultsController<ImporterType.EntityType> = {
        let fetchRequest: NSFetchRequest<ImporterType.EntityType> = ImporterType.EntityType.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "semester_id", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    lazy var context: NSManagedObjectContext = {
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        let tuition = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = tuition.semester_bezeichnung
        return cell
    }
    
}
