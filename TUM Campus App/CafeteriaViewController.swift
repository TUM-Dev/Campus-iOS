//
//  CafeteriaViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import ASWeekSelectorView
import AYSlidingPickerView

class CafeteriaViewController: UIViewController, DetailView {
    
    @IBOutlet weak var tableView: UITableView!
    var weekSelector: ASWeekSelectorView?
    var pickerView = AYSlidingPickerView()
    var barItem: UIBarButtonItem?
    
    var delegate: DetailViewDelegate?
    
    var categories = [(String,[CafeteriaMenu])]()
    
    var cafeterias = [Cafeteria]()
    var currentCafeteria: Cafeteria? {
        didSet {
            if let cafe = currentCafeteria {
                title = cafe.name
            }
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
        tableView.rowHeight = UITableViewAutomaticDimension
        delegate?.dataManager().getCafeterias(self)
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
    }
    
}

extension CafeteriaViewController {
    
    func showCafeterias(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(CafeteriaViewController.hideCafeterias(_:))
        barItem?.image = UIImage(named: "collapse")
    }
    
    func hideCafeterias(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(CafeteriaViewController.showCafeterias(_:))
        barItem?.image = UIImage(named: "expand")
    }
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for item in cafeterias {
            let item = AYSlidingPickerViewItem(title: item.name) { (did) in
                if did {
                    self.currentCafeteria = item
                    self.barItem?.action = #selector(CafeteriaViewController.showCafeterias(_:))
                    self.barItem?.image = UIImage(named: "expand")
                }
            }
            items.append(item!)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.mainView = navigationController?.view ?? view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        pickerView.didDismissHandler = { self.hideCafeterias(nil) }
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(CafeteriaViewController.showCafeterias(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
}

extension CafeteriaViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        cafeterias.removeAll()
        for item in data {
            if let cafeteria = item as? Cafeteria {
                cafeterias.append(cafeteria)
            }
        }
        currentCafeteria = cafeterias.first
        setUpPickerView()
        reloadItems()
    }
    
}

extension CafeteriaViewController: ASWeekSelectorViewDelegate {
    
    func weekSelector(_ weekSelector: ASWeekSelectorView!, didSelect date: Date!) {
        currentDate = date
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
