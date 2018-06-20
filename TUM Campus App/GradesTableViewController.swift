//
//  GradeTableViewController.swift
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

class GradesTableViewController: RefreshableTableViewController<Grade>, DetailViewDelegate, DetailView  {
    
    weak var delegate: DetailViewDelegate?
    
    func dataManager() -> TumDataManager? {
        return delegate?.dataManager()
    }
    
    override func fetch(skipCache: Bool) -> Promise<[Grade], APIError>? {
        return delegate?.dataManager()?.gradesManager.fetch(skipCache: skipCache)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "Grades"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "grade") as? GradeTableViewCell ?? GradeTableViewCell()
        cell.grade = values[indexPath.row]
        return cell
    }
    
}
