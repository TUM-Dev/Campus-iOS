//
//  GradeTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/21/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import XMLParsing


class GradeTableViewController: UITableViewController, EntityTableViewControllerProtocol {    
    typealias ImporterType = Importer<Grade,Grades,XMLDecoder>
    
    var endpoint: URLRequestConvertible = TUMOnlineAPI.personalGrades
    lazy var importer = ImporterType(context: context, endpoint: endpoint, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))

    lazy var fetchedResultsController: NSFetchedResultsController<ImporterType.EntityType> = {
        let fetchRequest: NSFetchRequest<ImporterType.EntityType> = ImporterType.EntityType.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lv_semester", ascending: false)]
        
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
        let grade = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = grade.lv_titel
        return cell
    }

}
