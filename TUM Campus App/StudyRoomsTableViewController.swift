//
//  StudyRoomsTableViewController.swift
//  TUM Campus App
//
//  Created by Max Muth on 18.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import AYSlidingPickerView

class StudyRoomsTableViewController: UITableViewController, DetailView {
    
    var delegate: DetailViewDelegate?
    
    var pickerView = AYSlidingPickerView()
    var barItem: UIBarButtonItem?
    
    var refresh = UIRefreshControl()
    func refresh(_ sender: AnyObject?) {
        roomGroups.removeAll()
        studyRooms.removeAll()
        delegate?.dataManager().getAllStudyRooms(self)
    }

    
    var roomGroups = [StudyRoomGroup]()
    var studyRooms = [StudyRoom]() // Rooms of all available groups
    var currentGroup: StudyRoomGroup? {
        didSet {
            title = currentGroup?.name
            currentRooms = self.studyRooms
                .filter() { (self.currentGroup?.roomNumbers.contains($0.roomNumber)) ?? false }
                .sorted() { $0.status.sortIndex < $1.status.sortIndex }
        }
    }
    var currentRooms = [StudyRoom]() { // Rooms for the group that is currently selected
        didSet {
            tableView.reloadData()
            refresh.endRefreshing()
        }
    }
    
}

extension StudyRoomsTableViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) { // Is called twice, once with [StudyRoomGroups] as argument, once for [StudyRooms]
        for item in data {
            if let group = item as? StudyRoomGroup {
                roomGroups.append(group)
            } else if let room = item as? StudyRoom {
                studyRooms.append(room)
            }
        }
        currentGroup = roomGroups.first
        setUpPickerView()
    }
}

extension StudyRoomsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        refresh.addTarget(self, action: #selector(StudyRoomsTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        refresh(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? RoomFinderViewController {
            if let selectedIndex = tableView.indexPathForSelectedRow?.row {
                mvc.room = currentRooms[selectedIndex]
            }
        }
    }

}

extension StudyRoomsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyRoom") as? StudyRoomsTableViewCell ?? StudyRoomsTableViewCell()
        cell.studyRoomItem = currentRooms[indexPath.row]
        return cell
    }
    
}

extension StudyRoomsTableViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager(user: nil)
    }
    
}

extension StudyRoomsTableViewController {
    
    func showRooms(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(StudyRoomsTableViewController.hideRooms(_:))
        barItem?.image = UIImage(named: "collapse")
    }
    
    func hideRooms(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(StudyRoomsTableViewController.showRooms(_:))
        barItem?.image = UIImage(named: "expand")
    }
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for group in roomGroups {
            let item = AYSlidingPickerViewItem(title: group.name) { (did) in
                if did {
                    self.currentGroup = group
                    self.barItem?.action = #selector(StudyRoomsTableViewController.showRooms(_:))
                    self.barItem?.image = UIImage(named: "expand")
                }
            }
            items.append(item!)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.mainView = view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(StudyRoomsTableViewController.showRooms(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
}
