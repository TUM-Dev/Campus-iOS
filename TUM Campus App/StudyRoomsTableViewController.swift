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
            refresh.endRefreshing()
        }
    }

//    var roomGroups = [StudyRoomGroup]()
    
    var delegate: DetailViewDelegate?
    
    var refresh = UIRefreshControl()
    
    func refresh(_ sender: AnyObject?) {
        delegate?.dataManager().getAllStudyRooms(self)
    }
    
}

extension StudyRoomsTableViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        studyRooms = data.flatMap() { $0 as? StudyRoom }
    }
}

extension StudyRoomsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Study Rooms"
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        refresh.addTarget(self, action: #selector(StudyRoomsTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? RoomFinderViewController {
            if let selectedIndex = tableView.indexPathForSelectedRow?.row {
                mvc.room = studyRooms[selectedIndex]
            }
        }
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
    
}

extension StudyRoomsTableViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager(user: nil)
    }
    
}
