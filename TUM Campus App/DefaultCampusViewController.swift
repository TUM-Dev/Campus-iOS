//
//  DefaultCampusViewController.swift
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
