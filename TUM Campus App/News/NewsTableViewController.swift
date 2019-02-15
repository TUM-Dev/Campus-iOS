//
//  NewsTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/4/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData

class NewsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var coreDataStack = appDelegate.persistentContainer
    var newsImporter: NewsImporter?
    var news: [News] = []
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<News> = {
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = coreDataStack.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        newsImporter = NewsImporter(context: context)
        newsImporter?.fetchNews()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        
        let article = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = article.title
        
        return cell
    }
    
    
}
