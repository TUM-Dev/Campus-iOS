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
    typealias ImporterType = Importer<Tuition,TuitionAPIResponse,XMLDecoder>
    
    let endpoint: URLRequestConvertible = TUMOnlineAPI.tuitionStatus
    let sortDescriptor = NSSortDescriptor(keyPath: \Tuition.semesterID, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
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
        guard let tuition = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.textLabel?.text = tuition.semester
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
