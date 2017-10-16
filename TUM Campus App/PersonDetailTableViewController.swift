//
//  PersonDetailTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/23/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class PersonDetailTableViewController: UITableViewController, DetailView {
    
    var user: DataElement?
    
    var delegate: DetailViewDelegate?
    
    var contactInfo = [(ContactInfoType,String)]()
    
    var addingContact = false
    
    func addContact(_ sender: AnyObject?) {
        let handler = { () in
            DoneHUD.showInView(self.view, message: "Contact Added")
        }
        if let data = user as? UserData {
            if data.contactsLoaded {
                addingContact = false
                data.addContact(handler)
            } else {
                addingContact = true
            }
        }
    }
}

extension PersonDetailTableViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        if let data = user as? UserData {
            contactInfo = data.contactInfo
        }
        if addingContact {
            addContact(nil)
        }
        tableView.reloadData()
    }
    
}

extension PersonDetailTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        title = user?.text
        let barItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PersonDetailTableViewController.addContact(_:)))
        navigationItem.rightBarButtonItem = barItem
        if let data = user as? UserData {
            delegate?.dataManager().getPersonDetails(self.receiveData, user: data)
            contactInfo = data.contactInfo
        }
    }
    
}

extension PersonDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return contactInfo.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && !contactInfo.isEmpty {
            return "Contact Info"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let data = user {
                let cell = tableView.dequeueReusableCell(withIdentifier: data.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
                cell.setElement(data)
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact") ?? UITableViewCell()
        if indexPath.row < contactInfo.count {
            cell.textLabel?.text = contactInfo[indexPath.row].0.rawValue
            cell.detailTextLabel?.text = contactInfo[indexPath.row].1
        } else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row < contactInfo.count {
            contactInfo[indexPath.row].0.handle(contactInfo[indexPath.row].1)
        }
    }
    
}
