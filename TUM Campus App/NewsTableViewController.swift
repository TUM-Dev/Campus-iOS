//
//  NewsTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, DetailView {
    
    var news = [News]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var delegate: DetailViewDelegate?

}

extension NewsTableViewController: TumDataReceiver {
    
    func receiveData(data: [DataElement]) {
        news = data.flatMap() { $0 as? News }
    }
    
}

extension NewsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.dataManager().getAllNews(self)
        title = "News"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
}

extension NewsTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("news") as? NewsTableViewCell ?? NewsTableViewCell()
        cell.newsItem = news[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        news[indexPath.row].open()
    }
    
}
