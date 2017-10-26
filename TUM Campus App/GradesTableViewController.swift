//
//  GradeTableViewController.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class GradesTableViewController: UITableViewController, DetailViewDelegate, DetailView  {

    var grades = [Grade]()
    
    weak var delegate: DetailViewDelegate?
    
    func dataManager() -> TumDataManager? {
        return delegate?.dataManager()
    }
    
    func fetch() {
        delegate?.dataManager()?.gradesManager.fetch().onSuccess(in: .main) { grades in
            self.grades = grades
            self.tableView.reloadData()
        }
    }
    
}

extension GradesTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        title = "Grades"
        delegate?.dataManager().getGrades(self)
        self.fetch()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

extension GradesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "grade") as? GradeTableViewCell ?? GradeTableViewCell()
        cell.grade = grades[indexPath.row]
        return cell
    }
    
}

