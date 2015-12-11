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

class CafeteriaViewController: UIViewController, TumDataReceiver, ASWeekSelectorViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: DetailViewDelegate?
    
    var currentCafeteria: Cafeteria? {
        didSet {
            if let cafe = currentCafeteria {
                title = cafe.name
            }
            reloadItems()
        }
    }
    
    var categories = [(String,[CafeteriaMenu])]()
    
    var cafeterias = [Cafeteria]()
    
    var weekSelector: ASWeekSelectorView?
    
    var currentDate = NSDate() {
        didSet {
            reloadItems()
        }
    }
    
    var pickerView = AYSlidingPickerView()
    
    var barItem: UIBarButtonItem?
    
    @IBOutlet weak var tableView: UITableView!
    
    func reloadItems() {
        categories.removeAll()
        let items = currentCafeteria?.getMenusForDate(currentDate)
        let categoriesArray = items?.reduce([String]()) { (array,element) in
            let type = element.typeLong.componentsSeparatedByString(" ")[0]
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
                    return item.typeLong.componentsSeparatedByString(" ")[0] == category
                }))!))
            }
        }
        tableView.reloadData()
    }

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
        weekSelector?.selectedDate = NSDate()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(weekSelector!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showCafeterias(send: AnyObject?) {
        pickerView.show()
        barItem?.action = Selector("hideCafeterias:")
        barItem?.image = UIImage(named: "collapse")
    }
    
    func hideCafeterias(send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = Selector("showCafeterias:")
        barItem?.image = UIImage(named: "expand")
    }
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for item in cafeterias {
            let item = AYSlidingPickerViewItem(title: item.name) { (did) in
                if did {
                    self.currentCafeteria = item
                    self.barItem?.action = Selector("showCafeterias:")
                    self.barItem?.image = UIImage(named: "expand")
                }
            }
            items.append(item)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.mainView = view
        pickerView.items = items
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.Plain, target: self, action:  Selector("showCafeterias:"))
        navigationItem.rightBarButtonItem = barItem
    }
    
    func receiveData(data: [DataElement]) {
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].1.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = categories[indexPath.section].1[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(item.getCellIdentifier() ?? "") as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(item)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = Constants.tumBlue
            header.textLabel?.textColor = UIColor.whiteColor()
        }
    }
    
    func weekSelector(weekSelector: ASWeekSelectorView!, didSelectDate date: NSDate!) {
        currentDate = date
    }
    
}
