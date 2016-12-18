//
//  StudyRoomsTableViewController.swift
//  TUM Campus App
//
//  Created by Max Muth on 18.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class StudyRoomsTableViewController: UITableViewController, DetailView {
    
    var studyRooms = [StudyRoom]() {
        didSet {
            tableView.reloadData()
        }
    }

//    var roomGroups = [StudyRoomGroup]()
    
    var delegate: DetailViewDelegate?
    
}

extension StudyRoomsTableViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        studyRooms = data.flatMap() { $0 as? StudyRoom }
    }
}

extension StudyRoomsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.dataManager().getAllStudyRooms(self)
        title = "Study Rooms"
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
}

extension StudyRoomsTableViewController {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return roomGroups.count
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return roomGroups[section].name
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return roomGroups[section].roomNumbers.count
        return studyRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyRoom") as? StudyRoomsTableViewCell ?? StudyRoomsTableViewCell()
        cell.studyRoomItem = studyRooms[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        news[indexPath.row].open()
    }
    
}
