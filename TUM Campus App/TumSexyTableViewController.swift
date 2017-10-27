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
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    func fetch() {
        delegate?.dataManager()?.tumSexyManager.fetch().onSuccess(in: .main) { entries in
            self.entries = entries
            self.tableView.reloadData()
        }
    }
    
    @IBAction func visit(_ sender: Any) {
        "http://tum.sexy".url?.open(sender: self)
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
        entries[indexPath.row].open(sender: self)
    }
    
}
