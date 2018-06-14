//
//  StudyRoomsTableViewController.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import Sweeft
import AYSlidingPickerView

class StudyRoomsTableViewController: UITableViewController, DetailView {
    
    weak var delegate: DetailViewDelegate?
    
    var pickerView = AYSlidingPickerView()
    var barItem: UIBarButtonItem?
    
    var refresh = UIRefreshControl()
    
    var roomGroups = [StudyRoomGroup]()
    
    var currentGroup: StudyRoomGroup? {
        didSet {
            title = currentGroup?.name
            currentRooms = self.currentGroup?.rooms.sorted(ascending: \.status.sortIndex) ?? []
        }
    }
    
    var currentRooms = [StudyRoom]() { // Rooms for the group that is currently selected
        didSet {
            tableView.reloadData()
            refresh.endRefreshing()
        }
    }
    
    @objc func refresh(_ sender: AnyObject?) {
        delegate?.dataManager()?.studyRoomsManager.fetch().onSuccess(in: .main) { result in
            self.roomGroups = result
            self.currentGroup = self.roomGroups.first
            self.setUpPickerView()
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
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
    
    func dataManager() -> TumDataManager? {
        return delegate?.dataManager()
    }
    
}

extension StudyRoomsTableViewController {
    
    @objc func showRooms(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(StudyRoomsTableViewController.hideRooms(_:))
        barItem?.image = UIImage(named: "collapse")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func hideRooms(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(StudyRoomsTableViewController.showRooms(_:))
        barItem?.image = UIImage(named: "expand")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
        pickerView.mainView = navigationController?.view ?? view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        pickerView.didDismissHandler = { self.hideRooms(nil) }
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(StudyRoomsTableViewController.showRooms(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
}
