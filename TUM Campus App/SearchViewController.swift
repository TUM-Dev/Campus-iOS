//
//  SearchViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, DetailView {
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    var delegate: DetailViewDelegate?
    
    var elements = [DataElement]()
    
    var currentElement: DataElement?

}

extension SearchViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager(user: nil)
    }
    
}

extension SearchViewController: TumDataReceiver, ImageDownloadSubscriber {
    
    func receiveData(data: [DataElement]) {
        elements = data
        for element in elements {
            if let downloader = element as? ImageDownloader {
                downloader.subscribeToImage(self)
            }
        }
        tableView.reloadData()
    }
    
    func updateImageView() {
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string != " " {
            for element in elements {
                if let downloader = element as? ImageDownloader {
                    downloader.clearSubscribers()
                }
            }
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
    
}

extension SearchViewController {
    
    override func viewDidLoad() {
        searchTextField.becomeFirstResponder()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = 102
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var mvc = segue.destinationViewController as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destinationViewController as? RoomFinderViewController {
            mvc.room = currentElement
        }
        if let mvc = segue.destinationViewController as? PersonDetailTableViewController {
            mvc.user = currentElement
        }
        if let mvc = segue.destinationViewController as? LectureDetailsTableViewController {
            mvc.lecture = currentElement
        }
    }
    
}

extension SearchViewController {
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        currentElement = elements[indexPath.row]
        return indexPath
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(elements[indexPath.row].getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(elements[indexPath.row])
        return cell
    }
    
}
