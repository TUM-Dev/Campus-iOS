//
//  GradeTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/21/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import XMLParsing


class GradeTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ResponseType = APIResponse<GradesAPIResponse, TUMOnlineAPIError>
    typealias ImporterType = Importer<Grade,ResponseType,XMLDecoder>
    
    let endpoint: URLRequestConvertible = TUMOnlineAPI.personalGrades
    let sortDescriptor = NSSortDescriptor(keyPath: \Grade.semester, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        importer.fetchedResultsControllerDelegate = self
        importer.performFetch { error in
            print(error)
        }
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Grades"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! importer.fetchedResultsController.performFetch()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSections : Int = importer.fetchedResultsController.sections?.count ?? 0
        if numOfSections>0
        {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else
        {
            setBackgroundLabel(with: "No Grades")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! GradeCell
        guard let grade = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.titleLabel.text = grade.title
        cell.gradeLabel.text = grade.grade
        cell.selectionStyle = .none
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }

}
