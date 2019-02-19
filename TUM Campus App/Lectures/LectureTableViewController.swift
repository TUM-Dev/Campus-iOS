//
//  LectureTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData

class LecturesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var coreDataStack = appDelegate.persistentContainer
    var lectureImporter: LectureImporter?
    var lectures: [Lecture] = []
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Lecture> = {
        let fetchRequest: NSFetchRequest<Lecture> = Lecture.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "semester_id", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        lectureImporter = LectureImporter(context: context)
        lectureImporter?.fetchLectures()
        try! fetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        try! fetchedResultsController.performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let news = fetchedResultsController.fetchedObjects
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureCell", for: indexPath)
        let lecture = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = lecture.stp_sp_title
        
        return cell
    }
    
    
}

