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


class StudyRoomGroupsTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<StudyRoomGroup,StudyRoomAPIResponse,JSONDecoder>
    
    let endpoint: URLRequestConvertible = TUMDevAppAPI.rooms
    let sortDescriptor = NSSortDescriptor(keyPath: \StudyRoomGroup.sorting, ascending: false)
    lazy var importer: ImporterType = Importer(endpoint: endpoint, sortDescriptor: sortDescriptor)

    override func viewDidLoad() {
        super.viewDidLoad()
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Study Rooms"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSections = importer.fetchedResultsController.sections?.count ?? 0
        if numOfSections > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else {
            setBackgroundLabel(with: "No Study Rooms")
        }
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! StudyRoomGroupedTableViewCell
        guard let roomGroup = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
        
        cell.titleLabel.text = roomGroup.name
        cell.numberLabel.text = "\(roomGroup.rooms?.count ?? 0)"
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
    
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
