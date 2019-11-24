//
//  LectureTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import XMLParsing
import Alamofire

class LecturesTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ImporterType = Importer<Lecture, LectureAPIResponse, XMLDecoder>
    
    let endpoint: URLRequestConvertible = TUMOnlineAPI.personalLectures
    let sortDescriptor = NSSortDescriptor(keyPath: \Lecture.semesterID, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Lectures"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSections = importer.fetchedResultsController.sections?.count ?? 0
        if numOfSections > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else {
            setBackgroundLabel(with: "No Lectures")
        }
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return importer.fetchedResultsController.sections?[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureCell", for: indexPath) as! LectureCell
        guard let lecture = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.titleLabel.text = lecture.title
        cell.detailsLabel.text = "Speaker: "+(lecture.speaker ?? "")
        cell.selectionStyle = .none
        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
