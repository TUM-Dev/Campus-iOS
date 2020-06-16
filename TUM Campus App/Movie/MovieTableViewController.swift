//
//  MovieTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

final class MovieTableViewController: UITableViewController {
   typealias ImporterType = Importer<Movie,[Movie],JSONDecoder>
    
    private static let endpoint = TUMCabeAPI.movie
    private static let sortDescriptor = NSSortDescriptor(keyPath: \Movie.date, ascending: false)
    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMddhhmmss))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        importer.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath)
//        let movie = importer.fetchedResultsController.object(at: indexPath)
//
//        cell.textLabel?.text = movie.title
        return UITableViewCell()
    }
    
}
