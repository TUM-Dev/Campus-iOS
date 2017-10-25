//
//  DeparturesViewController.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 17.06.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import UIKit

class DeparturesViewController : UITableViewController, DetailView {
    
    weak var delegate: DetailViewDelegate?
    
    let station: Station
    
    var departures: [Departure]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(station: Station) {
        self.station = station
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        title = station.name
        
        tableView.register(DepartureTableViewCell.self, forCellReuseIdentifier: DepartureTableViewCell.Identifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🗺️", style: .plain, target: self, action: #selector(openInMaps))
        
        refresh()
    }
    
    func refresh() {
        delegate?.dataManager()?.mvgManager.fetch(for: station).onSuccess(in: .main) { departures in
            self.departures = departures
            self.tableView.refreshControl?.endRefreshing()
        }
        .onError(in: .main) { error in
            if case .invalidStatus(_, let data) = error {
                print(data!.string!)
            }
            self.showError("Error", error.localizedDescription)
        }
    }
    
    func openInMaps() {
        // TODO add a pin to the map
        
        // https://developer.apple.com/library/content/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
        // https://developers.google.com/maps/documentation/urls/ios-urlscheme
        // https://developers.google.com/maps/documentation/ios-sdk/urlscheme
        
        let appleMapsUrl  = URL(string: "https://maps.apple.com/?sll=\(station.latitude),\(station.longitude)")!
        
        // zoom: int between 0 and 21 
        let googleMapsUrl = URL(string: "comgooglemaps://?center=\(station.latitude),\(station.longitude)&zoom=17&views=transit")!
        
        let googleMapsInstalled = UIApplication.shared.canOpenURL(googleMapsUrl)
        
        UIApplication.shared.open(googleMapsInstalled ? googleMapsUrl : appleMapsUrl)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departures?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DepartureTableViewCell(departure: departures![indexPath.row])
        
        return cell
    }
}
