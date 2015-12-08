//
//  SearchViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UITextFieldDelegate, TumDataReceiver {
    
    var delegate: DetailViewDelegate?
    
    var elements = [DataElement]()
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        searchTextField.becomeFirstResponder()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillDisappear(animated: Bool) {
        searchTextField.resignFirstResponder()
    }
    
    func receiveData(data: [DataElement]) {
        elements = data
        tableView.reloadData()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string != " " {
            let replaced = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
            if  replaced != "" {
                delegate?.dataManager().search(self, query: replaced)
            } else {
                elements = []
                tableView.reloadData()
            }
        }
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(elements[indexPath.row].getCellIdentifier()) ?? UITableViewCell()
        cell.textLabel?.text = elements[indexPath.row].text
        return cell
    }
    

}
