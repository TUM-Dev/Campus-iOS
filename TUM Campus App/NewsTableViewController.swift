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
    
    func fetch(scrolling: Bool = false) {
        delegate?.dataManager()?.newsManager.fetch().onSuccess(in: .main) { news in
            self.news = news
            
            guard scrolling, let index = news.lastIndex(where: { $0.date > .now }) else {
                return
            }
            
            let indexPath =  IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath,
                                       at: UITableViewScrollPosition.top,
                                       animated: false)
        }
    }
    
}

extension NewsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        delegate?.dataManager().getAllNews(self)
        self.fetch(scrolling: true)
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
