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
    private var dataSource: UITableViewDiffableDataSource<Section, Room>?

    private enum Section: CaseIterable {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Rooms".localized
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        setupDataSource()
        title = "Room Finder".localized
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Room>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, room: Room) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.reuseIdentifier, for: indexPath) as! RoomCell

            cell.configure(room: room)

            return cell
        }
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchString = searchBar.text else { return }
        let endpoint = TUMCabeAPI.roomSearch(query: searchString)
        sessionManager.request(endpoint).responseDecodable(of: [Room].self, decoder: JSONDecoder()) { [weak self] response in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([.main])
            snapshot.appendItems(response.value ?? [], toSection: .main)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

}
