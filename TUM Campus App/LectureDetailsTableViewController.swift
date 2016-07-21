//
//  LectureDetailsTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 1/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class LectureDetailsTableViewController: UITableViewController, DetailView {
    
    var lecture: DataElement?
    
    var delegate: DetailViewDelegate?

}

extension LectureDetailsTableViewController: TumDataReceiver {
    
    func receiveData(data: [DataElement]) {
        tableView.reloadData()
    }
    
}

extension LectureDetailsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        if let lectureUnwrapped = lecture as? Lecture {
            delegate?.dataManager().getLectureDetails(self, lecture: lectureUnwrapped)
            title = lectureUnwrapped.text
        }
    }
    
}

extension LectureDetailsTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let lectureUnwrapped = lecture as? Lecture {
            return lectureUnwrapped.details.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let lectureUnwrapped = lecture as? Lecture {
            return lectureUnwrapped.details[section].0
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detail") as? LectureDetailTableViewCell ?? LectureDetailTableViewCell()
        if let lectureUnwrapped = lecture as? Lecture {
            cell.label?.text = lectureUnwrapped.details[indexPath.section].1
        } else {
            cell.label?.text = "Information Not Available"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}
