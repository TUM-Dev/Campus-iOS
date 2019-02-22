//
//  EntityTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/20/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire


protocol EntityTableViewControllerProtocol: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    associatedtype ImporterType: ImporterProtocol
    var endpoint: URLRequestConvertible { get set }
    var importer: ImporterType { get }
    var coreDataStack: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    var fetchedResultsController: NSFetchedResultsController<ImporterType.EntityType> { get }
    var cellReuseID: String { get }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
}

extension EntityTableViewControllerProtocol {
    var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    var coreDataStack: NSPersistentContainer { return appDelegate.persistentContainer }
    var sortDescriptors: [NSSortDescriptor] { return [] }
    var cellReuseID: String { return "\(ImporterType.EntityType.self)Cell" }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let entities = fetchedResultsController.fetchedObjects
        return entities?.count ?? 0
    }
}
