//
//  PlansTableViewController.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 16.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class PlansTableViewController: UITableViewController {
    
    lazy var plans = Plans()
    var imageUrl: String!

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return plans.getPlans().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plan = plans.getPlan(forIndex: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlansTableViewCell

        // Configure the cell...
        cell.planTitleLabel.text = plan.title
        cell.planImageView.image = UIImage(named: plan.icon)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = plans.getPlan(forIndex: indexPath.row)
        
        if (plan.type == "image") {
            print(plan.url)
            performSegue(withIdentifier: "showDetail", sender: plan)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let nextScene = segue.destination as! PlanDetailsViewController
            let plan = sender as! Plan
            nextScene.imageUrl = plan.url
        }
    }

}
