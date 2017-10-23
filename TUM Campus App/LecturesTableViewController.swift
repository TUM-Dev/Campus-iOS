//
//  LecturesTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/10/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

class LecturesTableViewController: UITableViewController, TumDataReceiver, DetailViewDelegate, DetailView {
    
    var lectures = [(String,[DataElement])]()
    
    var delegate: DetailViewDelegate?
    
    var currentLecture: DataElement?
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager()
    }
    
    func receiveData(_ data: [DataElement]) {
        lectures.removeAll()
        let semesters = data.reduce([String](), { (array, element) in
            if let lecture = element as? Lecture {
                if !array.contains(lecture.semester) {
                    var newArray = array
                    newArray.append(lecture.semester)
                    return newArray
                }
            }
            return array
        })
        for semester in semesters {
            let lecturesInSemester = data.filter { (element: DataElement) in
                if let lecture = element as? Lecture {
                    return lecture.semester == semester
                }
                return false
            }
            lectures.append((semester,lecturesInSemester))
        }
        tableView.reloadData()
    }

}

extension LecturesTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        delegate?.dataManager().getLectures(self)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mvc = segue.destination as? LectureDetailsTableViewController {
            mvc.lecture = currentLecture
            mvc.delegate = self
        }
    }
    
}

extension LecturesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return lectures.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return lectures[section].0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = lectures[indexPath.section].1[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = Constants.tumBlue
            header.textLabel?.textColor = UIColor.white
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentLecture = lectures[indexPath.section].1[indexPath.row]
        return indexPath
    }
    
}
