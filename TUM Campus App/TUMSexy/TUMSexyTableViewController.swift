//
//  TUMSexyTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/26/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData

final class TUMSexyTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<TUMSexyLink,[String: TUMSexyLink],JSONDecoder>
    
    private let sortDescriptor = NSSortDescriptor(keyPath: \TUMSexyLink.linkDescription , ascending: false)
    lazy var importer: ImporterType = ImporterType(endpoint: TUMSexyAPI(), sortDescriptor: sortDescriptor)

    override func viewDidLoad() {
        super.viewDidLoad()
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        guard let link = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = link.linkDescription
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}


