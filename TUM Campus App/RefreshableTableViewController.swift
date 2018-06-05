//
//  RefreshableTableViewController.swift
//  Campus
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

class RefreshableTableViewController<Value: DataElement>: UITableViewController {
    
    var refresh = UIRefreshControl()
    
    var values = [Value]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        refresh()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    @objc func refresh(_ sender: AnyObject? = nil) {
        fetch(skipCache: sender != nil)?.onResult(in: .main) { result in
            self.values = result.value ?? []
            self.refresh.endRefreshing()
        }
    }
    
    func setupTableView() {
        
        refresh.addTarget(self,
                          action: #selector(RefreshableTableViewController<Value>.refresh(_:)),
                          for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresh)
        definesPresentationContext = true
    }
    
    func fetch(skipCache: Bool) -> Response<[Value]>? {
        return .successful(with: [])
    }
    
}
