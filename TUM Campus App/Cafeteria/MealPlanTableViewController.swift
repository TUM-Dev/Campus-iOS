//
//  MealPlanTableViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 5.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import Alamofire

final class MealPlanTableViewController: UITableViewController {
    private var endpoint: URLRequestConvertible? {
        guard let id = cafeteria?.id else { return nil }
        return EatAPI.menu(location: id)
    }
    private let sessionManager: Session = Session.defaultSession
    var cafeteria: Cafeteria? {
        didSet {
            title = cafeteria?.name
        }
    }
    private var menus: [Menu] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch()
    }

    private func fetch() {
        guard let endpoint = endpoint else { return }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        sessionManager.request(endpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { response in
            self.menus = response.value?.days.filter({ !$0.dishes.isEmpty }).sorted(by: >) ?? []
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MenuCollectionViewController") as? MenuCollectionViewController else { return }
        destination.menu = menus[indexPath.row]
        navigationController?.pushViewController(destination, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        let menu = menus[indexPath.row]
        if let date = menu.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            cell.textLabel?.text = formatter.string(from: date)
        }

        return cell
    }
    
}
