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
    private let sessionManager = Session.defaultSession
    private var menus: [Menu] = []
    var cafeteria: Cafeteria?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        tableView.tableFooterView = UIView()
        title = cafeteria?.name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch()
    }

    @objc private func fetch() {
        guard let cafeteria = cafeteria else { return }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        menus.removeAll()
        let thisWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: Date().year, week: Date().weekOfYear)
        sessionManager.request(thisWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [weak self] response in
            guard let value = response.value else { return }
            self?.menus.append(contentsOf: value.days.filter({ !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false) }))
            self?.menus.sort(by: <)
            self?.tableView.reloadData()
        }
        let calendar = Calendar.current
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: Date()) else { return }
        let nextWeekEndpoint = EatAPI.menu(location: cafeteria.id, year: nextWeek.year, week: nextWeek.weekOfYear)
        sessionManager.request(nextWeekEndpoint).responseDecodable(of: MealPlan.self, decoder: decoder) { [weak self] response in
            guard let value = response.value else { return }
            self?.menus.append(contentsOf: value.days.filter({ !$0.dishes.isEmpty && ($0.date?.isToday ?? false || $0.date?.isLaterThanOrEqual(to: Date()) ?? false) }))
            self?.menus.sort(by: <)
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menus.isEmpty {
            setBackgroundLabel(withText: "No Menu".localized)
        } else {
            removeBackgroundLabel()
        }
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
            formatter.dateFormat = "EEEE, MM.dd.yyyy"
            cell.textLabel?.text = formatter.string(from: date)
        }

        return cell
    }
    
}
