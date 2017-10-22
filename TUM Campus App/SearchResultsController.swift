//
//  SearchResultsController.swift
//  Campus
//
//  Created by Tim Gymnich on 22.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class SearchResultsController: UITableViewController {
    
    var delegate: DetailViewDelegate?
    var currentElement: DataElement?
    public var elements: [DataElement] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? RoomFinderViewController {
            mvc.room = currentElement
        }
        if let mvc = segue.destination as? PersonDetailTableViewController {
            mvc.user = currentElement
        }
        if let mvc = segue.destination as? LectureDetailsTableViewController {
            mvc.lecture = currentElement
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentElement = elements[indexPath.row]
        return indexPath
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: elements[indexPath.row].getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(elements[indexPath.row])
        return cell
    }
    
}

extension SearchResultsController: TumDataReceiver, ImageDownloadSubscriber {
    
    func receiveData(_ data: [DataElement]) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension SearchResultsController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager()
    }
    
}
