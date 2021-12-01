//
//  PersonSearchViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 2.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire
import XMLCoder

final class PersonSearchViewController: UITableViewController, UISearchResultsUpdating {
    private let sessionManager = Session.defaultSession
    private var dataSource: UITableViewDiffableDataSource<Section, Person>?

    private enum Section: CaseIterable {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Person Search".localized
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Students or Employees".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        setupDataSource()
    }

    // MARK: DataSource

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Person>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, person: Person) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)

            cell.textLabel?.text = "\(person.title?.appending(" ") ?? "")\(person.firstName) \(person.name)"

            return cell
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let person = dataSource?.itemIdentifier(for: indexPath),
            let detailVC = storyboard.instantiateViewController(withIdentifier: "PersonDetailCollectionViewController") as? PersonDetailCollectionViewController else { return }
        navigationController?.pushViewController(detailVC, animated: true)
        detailVC.setPerson(person)
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text, searchString.count > 3 else {
            sessionManager.cancelAllRequests()
            removeBackgroundLabel()
            return
        }

        let endpoint = TUMOnlineAPI.personSearch(search: searchString)
        sessionManager.cancelAllRequests()
        let request = sessionManager.request(endpoint)
        request.responseDecodable(of: TUMOnlineAPIResponse<Person>.self, decoder: XMLDecoder()) { [weak self] response in
            guard !request.isCancelled else {
                // cancelAllRequests doesn't seem to cancel all requests, so better check for this explicitly
                return
            }
            let value = response.value?.rows ?? []
            var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
            snapshot.appendSections([.main])
            snapshot.appendItems(value, toSection: .main)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)

            if value.isEmpty {
                let errorMessage = NSString(format: "Unable to find person".localized as NSString, searchString) as String
                self?.setBackgroundLabel(withText: errorMessage)
            } else {
                self?.removeBackgroundLabel()
            }
        }
    }


}
