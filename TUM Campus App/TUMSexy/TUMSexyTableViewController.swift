//
//  TUMSexyTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/26/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData

final class TUMSexyTableViewController: UITableViewController {
    typealias ImporterType = Importer<TUMSexyLink,[String: TUMSexyLink],JSONDecoder>
    
    private static let sortDescriptor = NSSortDescriptor(keyPath: \TUMSexyLink.linkDescription , ascending: true)
    private let importer = ImporterType(endpoint: TUMSexyAPI(), sortDescriptor: sortDescriptor)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Useful Links".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
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
            setBackgroundLabel(withText: "No Links".localized)
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
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TUMSexyLinkCell", for: indexPath)
        let link = importer.fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = link.linkDescription
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let link = importer.fetchedResultsController.object(at: indexPath)
        guard let urlString = link.target, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
}


