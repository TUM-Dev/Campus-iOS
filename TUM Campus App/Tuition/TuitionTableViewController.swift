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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        setupTableView()
        importer.fetchedResultsController.delegate = self
        title = "Tuition fees"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        fetch(animated: animated)
    }

    @objc private func fetch(animated: Bool = true) {
        if animated {
            tableView.refreshControl?.beginRefreshing()
        }
        importer.performFetch(success: { [weak self] in
            try? self?.importer.fetchedResultsController.performFetch()
            self?.tableView.refreshControl?.endRefreshing()
        }, error: { [weak self] error in
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: CalendarEvent.fetchRequest())
            _ = try? self?.importer.context.execute(deleteRequest)
            try? self?.importer.fetchedResultsController.performFetch()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
            self?.setBackgroundLabel(with: error.localizedDescription)
        })
    }

    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }

    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TuitionCell.reuseIdentifier, for: indexPath) as! TuitionCell
        guard let tuition = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.configure(tuition: tuition)
        
        return cell
    }

    // MARK: NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
