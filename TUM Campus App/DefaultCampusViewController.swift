//
//  DefaultCampusViewController.swift
//  Campus
//
//  Created by Tim Gymnich on 10/13/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit


class DefaultCampusViewController: UITableViewController {
    
    var currentlySelected: IndexPath?
    var locations: [Campus] = Campus.allCases
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = locations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCampusCell") ?? UITableViewCell(style: .default, reuseIdentifier: "DefaultCampusCell")
        cell.textLabel?.text = "\(item.rawValue)"
        if DefaultCampus.value == item {
            cell.accessoryType = .checkmark
            currentlySelected = indexPath
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let currentlySelected = currentlySelected {
            tableView.cellForRow(at: currentlySelected)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentlySelected = indexPath
        DefaultCampus.value = locations[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
