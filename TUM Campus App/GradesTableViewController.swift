//
//  GradeTableViewController.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
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
        title = "Grades"
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
