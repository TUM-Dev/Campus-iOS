//
//  CafeteriasTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

struct MensaAPIResponse: Decodable {
    var mensa_menu: [Menu]
    var mensa_beilagen: [SideDish]
    var mensa_preise: [Price]
}

class CafeteriasTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Cafeteria,[Cafeteria],JSONDecoder>
    
    let endpoint: URLRequestConvertible = TUMCabeAPI.cafeteria
    let sortDescriptor = NSSortDescriptor(key: "mensa", ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor)
    lazy var menuImporter = Importer<Menu,MensaAPIResponse,JSONDecoder>(endpoint: TUMDevAppAPI.cafeterias, sortDescriptor: NSSortDescriptor(key: "date", ascending: false), dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch()
        menuImporter.performFetch()
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
        guard let cafeteria = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.textLabel?.text = cafeteria.name
        cell.detailTextLabel?.text = "\(cafeteria.menu?.count ?? 0) / \(cafeteria.sides?.count ?? 0)"
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }

}
