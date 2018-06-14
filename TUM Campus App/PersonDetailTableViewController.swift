//
//  PersonDetailTableViewController.swift
//  TUM Campus App
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

class PersonDetailTableViewController: UITableViewController, DetailView {
    
    var user: DataElement?
    
    weak var delegate: DetailViewDelegate?
    
    var contactInfo: [(ContactInfoType, String)] {
        return (user as? UserData)?.contactInfo ?? []
    }
    
    var addingContact = false
    
    
    @objc func addContact(_ sender: AnyObject?) {
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

extension PersonDetailTableViewController {
    
    func fetch(for user: UserData) {
        delegate?.dataManager()?.personDetailsManager.fetch(for: user).onSuccess(in: .main) { user in
            self.user = user
            self.tableView.reloadData()
            if self.addingContact {
                self.addContact(nil)
            }
        }
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
            self.fetch(for: data)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
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
            contactInfo[indexPath.row].0.handle(contactInfo[indexPath.row].1, sender: self)
        }
    }
    
}
