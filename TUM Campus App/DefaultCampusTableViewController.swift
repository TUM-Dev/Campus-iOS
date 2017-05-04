//
//  DefaultCampusTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 03.05.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class DefaultCampusTableViewController: UITableViewController {
    
    @IBOutlet var campusSelectorCell: UITableViewCell!
    var campusSelectorExpanded = false
    @IBOutlet var cafeteriaSelectorCell: UITableViewCell!
    var cafeteriaSelectorExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Default Campus"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            campusSelectorExpanded = !campusSelectorExpanded
            UIView.animate(withDuration: 0.5) {
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        case 2:
            cafeteriaSelectorExpanded = !cafeteriaSelectorExpanded
            UIView.animate(withDuration: 0.5) {
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        default:
            break
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 1:
            if campusSelectorExpanded {
                return 220
            } else {
                return 0
            }
        case 3:
            if cafeteriaSelectorExpanded {
                return 220
            } else {
                return 0
            }
        default:
            return 44
        }
        
    }
    
}
