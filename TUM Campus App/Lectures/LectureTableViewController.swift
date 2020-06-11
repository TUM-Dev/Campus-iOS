//
//  LectureTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import XMLParsing
import Alamofire

final class LecturesTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Lecture, APIResponse<LectureAPIResponse,TUMOnlineAPIError>, XMLDecoder>
    
    private let endpoint: URLRequestConvertible = TUMOnlineAPI.personalLectures
    private let sortDescriptor = NSSortDescriptor(keyPath: \Lecture.semesterID, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        importer.fetchedResultsController.delegate = self
        title = "Lectures".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch(animated: animated)
    }

    @objc private func fetch(animated: Bool = true) {
        if animated {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.refreshControl?.beginRefreshing()
            }
        }
        importer.performFetch(success: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.reload()
        }, error: { [weak self] error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            switch error {
            case is TUMOnlineAPIError:
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: Lecture.fetchRequest())
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
            setBackgroundLabel(withText: "No Lectures".localized)
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

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return importer.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return importer.fetchedResultsController.sections?[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LectureCell.reuseIdentifier, for: indexPath) as! LectureCell
        let lecture = importer.fetchedResultsController.object(at: indexPath)
        cell.configure(lecture: lecture)
        
        return cell
    }
    
}
