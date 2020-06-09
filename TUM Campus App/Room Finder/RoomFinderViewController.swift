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
    private let errorMessageLabel = UILabel()
    private let sessionManager: Session = Session.defaultSession
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
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .secondaryLabel
        errorMessageLabel.font = .systemFont(ofSize: 19)
        errorMessageLabel.numberOfLines = 0
        
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
    
    /// Shows an error message stating that we were unable to find the room.
    /// - parameter roomName: The name of the room we were searching for. `nil` to remove the error message
    private func showUnableToFindRoomErrorMessage(roomName: String?) {
        guard let roomName = roomName else {
            tableView.backgroundView = nil
            return
        }
        tableView.backgroundView = errorMessageLabel
        errorMessageLabel.text = NSString(format: "Unable to find room".localized as NSString, roomName) as String
    }
    

    // MARK: - UITableViewDelegate

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
            showUnableToFindRoomErrorMessage(roomName: nil)
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
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([.main])
            if (response.value ?? []) == [] {
                self?.showUnableToFindRoomErrorMessage(roomName: searchString)
            } else {
                self?.showUnableToFindRoomErrorMessage(roomName: nil)
            }
            snapshot.appendItems(response.value ?? [], toSection: .main)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

}
