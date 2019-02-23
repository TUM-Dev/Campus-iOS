//
//  NewsTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/4/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class NewsTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<News,[News],JSONDecoder>
    
    var endpoint: URLRequestConvertible = TUMCabeAPI.news(news: "")
    lazy var importer = ImporterType(context: context, endpoint: endpoint, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))

    lazy var fetchedResultsController: NSFetchedResultsController<ImporterType.EntityType> = {
        let fetchRequest: NSFetchRequest<ImporterType.EntityType> = ImporterType.EntityType.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: cellReuseID)
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
        let article = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = article.title
        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
