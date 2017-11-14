//
//  TumSexyTableViewController.swift
//  TUM Campus App
//

import UIKit
import Sweeft

class TumSexyTableViewController: RefreshableTableViewController<SexyEntry>, DetailView {
    
    weak var delegate: DetailViewDelegate?
    
    override func fetch(skipCache: Bool) -> Promise<[SexyEntry], APIError>? {
        return delegate?.dataManager()?.tumSexyManager.fetch(skipCache: skipCache)
    }
    
    @IBAction func visit(_ sender: Any) {
        "http://tum.sexy".url?.open(sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sexy", for: indexPath) as? SexyEntryTableViewCell ?? SexyEntryTableViewCell()
        cell.entry = values[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        values[indexPath.row].open(sender: self)
    }
    
}
