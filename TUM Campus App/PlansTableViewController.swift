//
//  PlansTableViewController.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 16.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import Alamofire

class PlansTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    var plans: [Plan] {
        return Plans.shared.plans
    }
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }

    // load data into the rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plan = plans[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlansTableViewCell

        // Configure the cell...
        cell.planTitleLabel.text = plan.title
        cell.planImageView.image = UIImage(named: plan.icon)

        return cell
    }
    
    // set the height of the table row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
    // show detail view, when row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = plans[indexPath.row]
        
        performSegue(withIdentifier: "showDetail", sender: plan)
        
    }
    
    // set data for passing to details view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let nextScene = segue.destination as! PlanDetailsViewController
            let plan = sender as! Plan
            nextScene.planFileUrl = plan.fileUrl
            nextScene.planType = plan.type
        }
    }
    
    // download the plans
    private func downloadData() {
        for plan in plans {
            if (plan.type == .pdf) {
                let downloader = PlanDownloader()
                downloader.downloadPlan(urlString: plan.url, withName: plan.fileUrl)
            }
        }
    }

}
