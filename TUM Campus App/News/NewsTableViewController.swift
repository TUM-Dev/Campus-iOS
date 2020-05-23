//
//  NewsTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/4/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

final class NewsTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<News,[News],JSONDecoder>
    
    private let endpoint: URLRequestConvertible = TUMCabeAPI.news
    lazy var importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        importer.fetchedResultsController.delegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let article = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.textLabel?.text = article.title
        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
