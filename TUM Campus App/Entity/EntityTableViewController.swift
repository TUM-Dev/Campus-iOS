//
//  EntityTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/20/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire


protocol EntityTableViewControllerProtocol: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    associatedtype ImporterType: ImporterProtocol
    var importer: ImporterType { get }
    var cellReuseID: String { get }
}

extension EntityTableViewControllerProtocol {
    var cellReuseID: String { return "\(ImporterType.EntityType.self)Cell" }
}
