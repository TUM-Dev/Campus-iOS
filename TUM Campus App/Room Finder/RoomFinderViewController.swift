//
//  RoomFinderViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 24.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire

final class RoomFinderViewController: UITableViewController, UISearchResultsUpdating {
    private let sessionManager: Session = Session.defaultSession
    private var rooms: [Room] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Rooms"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
    }


    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let room = rooms[indexPath.row]

        cell.textLabel?.text = room.roomCode
        cell.detailTextLabel?.text = room.campus

        return cell
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchString = searchBar.text else { return }
        let endpoint = TUMCabeAPI.roomSearch(query: searchString)
        sessionManager.request(endpoint).responseDecodable(of: [Room].self, decoder: JSONDecoder()) { [weak self] response in
            self?.rooms = response.value ?? []
            self?.tableView.reloadData()
        }
    }

}
