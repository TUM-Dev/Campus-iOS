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


final class TuitionTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Tuition,TuitionAPIResponse,XMLDecoder>
    
    private let endpoint: URLRequestConvertible = TUMOnlineAPI.tuitionStatus
    private let sortDescriptor = NSSortDescriptor(keyPath: \Tuition.semesterID, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
    private var deadlineDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch()
        deadlineDateFormatter.locale = Locale.current
        deadlineDateFormatter.dateFormat = "dd MMM y"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! TuitionCell
        guard let tuition = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.semesterLabel.text = tuition.semester
        guard let amount = tuition.amount,
            let deadline = tuition.deadline else{return cell}
        cell.amountLabel.text = "Amount : \(amount)€"
        cell.deadlineLabel.text = "Deadline : \(deadlineDateFormatter.string(from: deadline))"
        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
