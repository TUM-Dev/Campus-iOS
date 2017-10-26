//
//  TumSexyTableViewController.swift
//  TUM Campus App
//

import UIKit

class TumSexyTableViewController: UITableViewController, DetailView {
    
    weak var delegate: DetailViewDelegate?
    
    var entries = [SexyEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        delegate?.dataManager().getSexyEntries(self)
    }
    
    @IBAction func visit(_ sender: Any) {
        guard let url = URL(string: "http://tum.sexy") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
}

extension TumSexyTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sexy", for: indexPath) as? SexyEntryTableViewCell ?? SexyEntryTableViewCell()
        cell.entry = entries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        entries[indexPath.row].open()
    }
    
}
