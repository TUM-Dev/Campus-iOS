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
    
    weak var delegate: DetailViewDelegate?

}

extension NewsTableViewController {
    
    func fetch() {
        delegate?.dataManager()?.newsManager.fetch().onSuccess(in: .main) { news in
            self.news = news
        }
    }
    
}

extension NewsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetch()
        title = "News"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
}

extension NewsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news") as? NewsTableViewCell ?? NewsTableViewCell()
        cell.newsItem = news[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        news[indexPath.row].open(sender: self)
    }
    
}
