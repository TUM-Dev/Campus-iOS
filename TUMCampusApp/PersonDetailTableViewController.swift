//
//  PersonDetailTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/23/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class PersonDetailTableViewController: UITableViewController, TumDataReceiver {
    
    var user: DataElement?
    
    var delegate: DetailViewDelegate?
    
    var contactInfo = [(ContactInfoType,String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        title = user?.text
        let barItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addContact:"))
        navigationItem.rightBarButtonItem = barItem
        if let data = user as? UserData {
            delegate?.dataManager().getPersonDetails(self.receiveData, user: data)
            contactInfo = data.contactInfo
        }
    }
    
    func receiveData(data: [DataElement]) {
        if let data = user as? UserData {
            contactInfo = data.contactInfo
        }
        if addingContact {
            addContact(nil)
        }
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return contactInfo.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && !contactInfo.isEmpty {
            return "Contact Info"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {          
        if indexPath.section == 0 {
            if let data = user {
                let cell = tableView.dequeueReusableCellWithIdentifier(data.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
                cell.setElement(data)
                return cell
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("contact") ?? UITableViewCell()
        cell.textLabel?.text = contactInfo[indexPath.row].0.rawValue
        cell.detailTextLabel?.text = contactInfo[indexPath.row].1
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            contactInfo[indexPath.row].0.handle(contactInfo[indexPath.row].1)
        }
    }
    
    var addingContact = false
    
    func addContact(sender: AnyObject?) {
        
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
