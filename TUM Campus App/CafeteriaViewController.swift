//
//  CafeteriaViewController.swift
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
import ASWeekSelectorView

class CafeteriaViewController: UIViewController, DetailView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weekSelector: ASWeekSelectorView?
    
    weak var delegate: DetailViewDelegate?
    
    var categories = [(String, [CafeteriaMenu])]()
    var cafeterias = [Cafeteria]()
    var currentCafeteria: Cafeteria? {
        didSet {
            if let cafe = currentCafeteria {
                title = cafe.name
            }
            weekSelector?.refresh()
            reloadItems()
        }
    }
    
    var currentDate = Date() {
        didSet {
            reloadItems()
        }
    }
    
    func reloadItems() {
        categories.removeAll()
        let items = currentCafeteria?.getMenusForDate(currentDate)
        let categoriesArray = items?.reduce([String]()) { (array,element) in
            let type = element.typeLong.components(separatedBy: " ")[0]
            if !array.contains(type) {
                var newArray = array
                newArray.append(type)
                return newArray
            }
            return array
        }
        if let array = categoriesArray {
            for category in array {
                categories.append((category,(items?.filter({ (item) in
                    return item.typeLong.components(separatedBy: " ")[0] == category
                }))!))
            }
        }
        tableView.separatorColor = categories.isEmpty ? UIColor.clear : UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
        tableView.reloadData()
    }
    
}

extension CafeteriaViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.fetch()
        
        let size = CGSize(width: view.frame.width, height: 80.0)
        let origin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y+64)
        weekSelector = ASWeekSelectorView(frame: CGRect(origin: origin, size: size))
        weekSelector?.firstWeekday = 2
        weekSelector?.letterTextColor = UIColor(white: 0.5, alpha: 1.0)
        weekSelector?.delegate = self
        weekSelector?.selectedDate = Date()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(weekSelector!)
        
        let barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: .plain, target: self,
                                      action:  #selector(CafeteriaViewController.showCafeterias(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
}

extension CafeteriaViewController: TUMPickerControllerDelegate {
    typealias Element = Cafeteria
    
    @objc func showCafeterias(_ send: UIBarButtonItem?) {
        let pickerView = TUMPickerController(elements: cafeterias, selected: currentCafeteria, delegate: self)
        pickerView.popoverPresentationController?.barButtonItem = send
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            let maxHeight = view.frame.height - UIApplication.shared.statusBarFrame.height * 2
            let heightConstraint = NSLayoutConstraint(
                item: pickerView.view, attribute: .height,
                relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: maxHeight)
            pickerView.view.addConstraint(heightConstraint)
        }
        
        present(pickerView, animated: true)
    }
    
    func didSelect(element: Cafeteria) {
        currentCafeteria = element
    }
    
}

extension CafeteriaViewController {
    
    func fetch() {
        delegate?.dataManager()?.cafeteriaManager.fetch().onSuccess(in: .main) { cafeterias in
            self.cafeterias = cafeterias
            self.currentCafeteria = cafeterias.first
            self.reloadItems()
        }
    }
    
}

extension CafeteriaViewController: ASWeekSelectorViewDelegate {
    
    func weekSelector(_ weekSelector: ASWeekSelectorView, didSelect date: Date) {
        currentDate = date
    }
    
    func weekSelector(_ weekSelector: ASWeekSelectorView, numberColorFor date: Date) -> UIColor? {
        return Constants.tumBlue
    }
    
    func weekSelector(_ weekSelector: ASWeekSelectorView, showIndicatorFor date: Date) -> Bool {
        return currentCafeteria.map { !$0.getMenusForDate(date).isEmpty } ?? false
    }
    
}

extension CafeteriaViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == categories.count {
            return nil
        }
        return categories[section].0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories.isEmpty {
            return 1
        }
        if section == categories.count {
            return 0
        }
        return categories[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == categories.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notavailable") ?? UITableViewCell()
            return cell
        }
        let item = categories[indexPath.section].1[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.topGradientColor = .white
        cell.bottomGradientColor = .white
        cell.setElement(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = Constants.tumBlue
            header.textLabel?.textColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
