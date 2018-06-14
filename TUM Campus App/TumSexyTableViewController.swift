//
//  TumSexyTableViewController.swift
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
