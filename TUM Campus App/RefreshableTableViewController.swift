//
//  RefreshableTableViewController.swift
//  Campus
//
//  Created by Mathias Quintero on 11/14/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
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
    
    func refresh(_ sender: AnyObject? = nil) {
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
