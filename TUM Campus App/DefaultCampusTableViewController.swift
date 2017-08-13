//
//  DefaultCampusTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 03.05.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class DefaultCampusTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var campusSelectorCell: UITableViewCell!
    @IBOutlet var campusSelector: UIPickerView!
    var campusSelectorExpanded = false
    var campus =  ["Garching", "Stammgelände"]
    @IBOutlet var cafeteriaSelectorCell: UITableViewCell!
    @IBOutlet var cafeteriaSelector: UIPickerView!
    var cafeteriaSelectorExpanded = false
    var cafeteria = ["Garching", "Stammgelände"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Default Campus"
        setupPickers()
    }
    
    func setupPickers() {
        campusSelector.numberOfRows(inComponent: campus.count)
        campusSelector.dataSource = self
        campusSelector.delegate = self
        cafeteriaSelector.numberOfRows(inComponent: cafeteria.count)
        cafeteriaSelector.dataSource = self
        cafeteriaSelector.delegate = self
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === cafeteriaSelector {
            return cafeteria.count
        } else if pickerView === campusSelector {
            return campus.count
        } else {
            return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("did Select row: \(row)")
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === cafeteriaSelector {
            return cafeteria[row]
        } else if pickerView === campusSelector {
            return campus[row]
        } else {
            return ""
        }
    }
    
}
