//
//  NewsTableViewController.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
