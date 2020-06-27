//
//  EventsTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/26/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

final class EventsTableViewController: UITableViewController {
    typealias ImporterType = TicketImporter
    
    private static let endpoint = TUMCabeAPI.events
    private static let sortDescriptor = NSSortDescriptor(keyPath: \TicketEvent.start, ascending: false)
    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: EventCollectionViewCell.reuseIdentifier, for: indexPath)
//        guard let event = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
//
//        cell.textLabel?.text = event.title
//        cell.detailTextLabel?.text = event.ticketType?.sold ?? "0"
        return UITableViewCell()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
