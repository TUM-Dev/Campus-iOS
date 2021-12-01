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


final class StudyRoomGroupsTableViewController: UITableViewController, ProfileImageSettable {
    typealias ImporterType = Importer<StudyRoomGroup,StudyRoomAPIResponse,JSONDecoder>

    @IBOutlet private weak var profileImageBarButtonItem: UIBarButtonItem!
    var profileImage: UIImage? {
        get { return profileImageBarButtonItem.image }
        set { profileImageBarButtonItem.image = newValue?.imageAspectScaled(toFill: CGSize(width: 32, height: 32)).imageRoundedIntoCircle().withRenderingMode(.alwaysOriginal) }
    }
    
    private static let endpoint = TUMDevAppAPI.rooms
    private static let sortDescriptor = NSSortDescriptor(keyPath: \StudyRoomGroup.name, ascending: false)
    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setupTableView()
        loadProfileImage()
        title = "Study Rooms".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            setBackgroundLabel(withText: "No Study Rooms".localized)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return importer.fetchedResultsController.sections?.count ?? 0
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
