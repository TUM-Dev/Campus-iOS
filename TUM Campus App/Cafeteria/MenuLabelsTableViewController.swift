//
//  MenuLabelsViewController.swift
//  TUMCampusApp
//
//  Created by Philipp Wenner on 24.01.22.
//  Copyright © 2022 TUM. All rights reserved.
//

import UIKit

class MenuLabelsTableViewController: UITableViewController {
    private var labels: [Label] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Labels"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    @objc private func fetch() {
        self.labels = Array(MensaEnumService.shared.getLabels().values)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.labels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        // set the text from the data model
        cell.textLabel?.text = self.labels[indexPath.row].abbreviation
        cell.detailTextLabel?.text = self.labels[indexPath.row].text["DE"]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

}
