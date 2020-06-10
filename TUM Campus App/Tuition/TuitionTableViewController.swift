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
            self?.tableView.refreshControl?.endRefreshing()
            self?.reload()
        }, error: { [weak self] error in
            self?.tableView.refreshControl?.endRefreshing()
            switch error {
            case is TUMOnlineAPIError:
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: Tuition.fetchRequest())
                _ = try? self?.importer.context.execute(deleteRequest)
                self?.reload()
            default: break
            }
            self?.setBackgroundLabel(withText: error.localizedDescription)
        })
    }

    private func reload() {
        try? importer.fetchedResultsController.performFetch()
        tableView.reloadData()

        switch importer.fetchedResultsController.fetchedObjects?.count {
        case let .some(count) where count > 0:
            removeBackgroundLabel()
        case let .some(count) where count == 0:
            setBackgroundLabel(withText: "No Tuition Fees".localized)
        default:
            break
        }
    }

    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }

    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TuitionCell.reuseIdentifier, for: indexPath) as! TuitionCell
        let tuition = importer.fetchedResultsController.object(at: indexPath)

        cell.configure(tuition: tuition)
        
        return cell
    }

}
