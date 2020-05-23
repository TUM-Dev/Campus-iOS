//
//  StudyRoomGroupsTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/26/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

struct StudyRoomAPIResponse: Decodable {
    var rooms: [StudyRoom]
    var groups: [StudyRoomGroup]
    
    enum CodingKeys: String, CodingKey {
        case rooms = "raeume"
        case groups = "gruppen"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // initializing order matters! rooms first, groups seconds :(
        let rooms = try container.decode([StudyRoom].self, forKey: .rooms)
        let groups = try container.decode([StudyRoomGroup].self, forKey: .groups)
        
        self.rooms = rooms
        self.groups = groups
    }
}


final class StudyRoomGroupsTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<StudyRoomGroup,StudyRoomAPIResponse,JSONDecoder>
    
    private let endpoint: URLRequestConvertible = TUMDevAppAPI.rooms
    private let sortDescriptor = NSSortDescriptor(keyPath: \StudyRoomGroup.sorting, ascending: false)
    lazy var importer: ImporterType = Importer(endpoint: endpoint, sortDescriptor: sortDescriptor)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        importer.fetchedResultsController.delegate = self
        title = "Study Rooms".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch(animated: animated)
    }

    @objc private func fetch(animated: Bool = true) {
        if animated {
            tableView.refreshControl?.beginRefreshing()
        }
        importer.performFetch(success: { [weak self] in
            try? self?.importer.fetchedResultsController.performFetch()
            self?.tableView.refreshControl?.endRefreshing()
        }, error: { [weak self] error in
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: CalendarEvent.fetchRequest())
            _ = try? self?.importer.context.execute(deleteRequest)
            try? self?.importer.fetchedResultsController.performFetch()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
            self?.setBackgroundLabel(with: error.localizedDescription)
        })
    }

    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
//        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }

    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = importer.fetchedResultsController.sections?.count

        switch numberOfSections {
        case let .some(count) where count > 0:
            tableView.backgroundView = nil
        case let .some(count) where count == 0:
            setBackgroundLabel(with: "No Study Rooms".localized)
        default:
            break
        }

        return numberOfSections ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudyRoomGroupedTableViewCell.reuseIdentifier, for: indexPath) as! StudyRoomGroupedTableViewCell
        guard let roomGroup = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.configure(group: roomGroup)

        return cell
    }

    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "studyRooms") {
            guard let roomsVC = segue.destination as? StudyRoomTableViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let roomGroup = importer.fetchedResultsController.fetchedObjects?[indexPath.row],
                let rooms = roomGroup.rooms?.allObjects as? [StudyRoom] else { return }
            roomsVC.rooms = rooms
            roomsVC.title = roomGroup.name
        }
    }
    
}
