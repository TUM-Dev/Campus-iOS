//
//  NewsTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

class NewsTableViewController: RefreshableTableViewController<News>, DetailView {
    
    weak var delegate: DetailViewDelegate?
    
    override func refresh(_ sender: AnyObject?) {
        fetch(skipCache: sender != nil)?.onResult(in: .main) { result in
            self.values = result.value ?? []
            self.refresh.endRefreshing()
            
            guard sender == nil,
                let index = self.values.lastIndex(where: { $0.date > .now }) else {
                
                return
            }
            let indexPath =  IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath,
                                       at: UITableViewScrollPosition.top,
                                       animated: false)
        }
    }
    
    override func fetch(skipCache: Bool) -> Promise<[News], APIError>? {
        return delegate?.dataManager()?.newsManager.fetch(skipCache: skipCache)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news") as? NewsTableViewCell ?? NewsTableViewCell()
        cell.newsItem = values[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        values[indexPath.row].open(sender: self)
    }
    
}
