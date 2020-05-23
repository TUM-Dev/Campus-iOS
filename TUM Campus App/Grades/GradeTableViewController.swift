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

final class GradeTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ResponseType = APIResponse<GradesAPIResponse, TUMOnlineAPIError>
    typealias ImporterType = Importer<Grade,ResponseType,XMLDecoder>
    
    private let endpoint: URLRequestConvertible = TUMOnlineAPI.personalGrades
    private let sortDescriptor = NSSortDescriptor(keyPath: \Grade.semester, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        importer.fetchedResultsController.delegate = self
        title = "Grades".localized
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
            try? self?.importer.fetchedResultsController.performFetch()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = importer.fetchedResultsController.sections?.count

        switch numberOfSections {
        case let .some(count) where count > 0:
            tableView.backgroundView = nil
        case let .some(count) where count == 0:
            setBackgroundLabel(with: "No Grades".localized)
        default:
            break
        }

        return numberOfSections ?? 0
    }
       
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return importer.fetchedResultsController.sections?[section].name
   }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GradeCell.reuseIdentifier, for: indexPath) as! GradeCell
        guard let grade = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.configure(grade: grade)
        
        return cell
    }

    // MARK: NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }

}
