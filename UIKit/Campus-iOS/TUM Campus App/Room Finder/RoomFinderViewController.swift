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
    private let sessionManager = Session.defaultSession
    private var dataSource: UITableViewDiffableDataSource<Section, Room>?

    private enum Section: CaseIterable {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Room Finder".localized
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Rooms".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        setupDataSource()
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Room>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, room: Room) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.reuseIdentifier, for: indexPath) as! RoomCell

            cell.configure(room: room)

            return cell
        }
    }
    

    // MARK: - UICollectionViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "RoomViewController") as? RoomViewController,
            let room = dataSource?.snapshot().itemIdentifiers[indexPath.row] else { return }

        destination.room = room
        navigationController?.pushViewController(destination, animated: true)
    }

    
    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        guard !searchString.isEmpty else {
            // Cancel currently running requests and clear the table when searching for an empty string.
            // This seems preferable over sending the empty string to the API and clearing the table via the (expectedly) empty response
            sessionManager.cancelAllRequests()
            self.removeBackgroundLabel()
            return
        }
        let endpoint = TUMCabeAPI.roomSearch(query: searchString)
        sessionManager.cancelAllRequests()
        let request = sessionManager.request(endpoint)
        request.responseDecodable(of: [Room].self, decoder: JSONDecoder()) { [weak self] response in
            guard !request.isCancelled else {
                // cancelAllRequests doesn't seem to cancel all requests, so better check for this explicitly
                return
            }
            let value = response.value ?? []
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([.main])
            snapshot.appendItems(value, toSection: .main)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)

            if value.isEmpty {
                let errorMessage = NSString(format: "Unable to find room".localized as NSString, searchString) as String
                self?.setBackgroundLabel(withText: errorMessage)
            } else {
                self?.removeBackgroundLabel()
            }
        }
    }

}
