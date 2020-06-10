//
//  CalendarTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import XMLParsing
import Alamofire

final class CalendarTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<CalendarEvent,APIResponse<CalendarAPIResponse,TUMOnlineAPIError>,XMLDecoder>
    
    private let endpoint: URLRequestConvertible = TUMOnlineAPI.calendar
    private let sortDescriptor = NSSortDescriptor(keyPath: \CalendarEvent.startDate, ascending: true)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        title = "Calendar".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
                guard let context = self?.importer.context else { break }
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: CalendarEvent.fetchRequest())
                _ = try? context.execute(deleteRequest) as? NSBatchDeleteResult
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
            setBackgroundLabel(withText: "No Calendar Events".localized)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return importer.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarEventCell.reuseIdentifier, for: indexPath) as! CalendarEventCell
        let event = importer.fetchedResultsController.object(at: indexPath)

        cell.configure(event: event)

        return cell
    }

}
