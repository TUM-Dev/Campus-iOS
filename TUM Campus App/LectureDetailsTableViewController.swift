//
//  LectureDetailsTableViewController.swift
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

class LectureDetailsTableViewController: UITableViewController, DetailView {
    
    var lecture: DataElement?
    
    weak var delegate: DetailViewDelegate?

}

extension LectureDetailsTableViewController {
    
    func fetch(lecture: Lecture) {
        delegate?.dataManager()?.lectureDetailsManager.fetch(for: lecture).onSuccess(in: .main) { lecture in
            self.lecture = lecture
            self.tableView.reloadData()
        }
    }
    
}

extension LectureDetailsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        if let lectureUnwrapped = lecture as? Lecture {
            
            title = lectureUnwrapped.text
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

extension LectureDetailsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let lectureUnwrapped = lecture as? Lecture {
            return lectureUnwrapped.details.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let lectureUnwrapped = lecture as? Lecture {
            return lectureUnwrapped.details[section].0
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail") as? LectureDetailTableViewCell ?? LectureDetailTableViewCell()
        if let lectureUnwrapped = lecture as? Lecture {
            cell.label?.text = lectureUnwrapped.details[indexPath.section].1
        } else {
            cell.label?.text = "Information Not Available"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
