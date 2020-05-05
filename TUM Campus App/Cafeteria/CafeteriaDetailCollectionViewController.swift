//
//  CafeteriaDetailCollectionViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CalendarKit
import ScrollableDatepicker

class CafeteriaDetailCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ScrollableDatepickerDelegate {
    @IBOutlet weak var datePicker: ScrollableDatepicker! {
        didSet {
            var dates = [Date]()
            for day in -15...15 {
                dates.append(Date(timeIntervalSinceNow: Double(day * 86400)))
            }
            
            datePicker.dates = dates
            datePicker.selectedDate = Date()
            datePicker.delegate = self
            
            var configuration = Configuration()
            configuration.weekendDayStyle.dateTextColor = .tumBlue
            configuration.weekendDayStyle.dateTextFont = UIFont.boldSystemFont(ofSize: 20)
            configuration.weekendDayStyle.weekDayTextColor = .tumBlue
            configuration.selectedDayStyle.backgroundColor = UIColor.tumBlue.withAlphaComponent(0.1)
            configuration.selectedDayStyle.selectorColor = .tumBlue
            configuration.daySizeCalculation = .numberOfVisibleItems(5)
            
            datePicker.configuration = configuration
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cafeteria: Cafeteria?
//    var menu: [Menu] {
//        if let menu = cafeteria?.menu?.allObjects as? [Menu] {
//            return menu.filter {
//                guard let date = $0.date, let selectedDate = datePicker.selectedDate else { return false }
//                return Calendar.current.isDate(date, inSameDayAs: selectedDate) }
//        }
//        return []
//    }
//    var sides: [SideDish] {
//        if let sides = cafeteria?.sides?.allObjects as? [SideDish] {
//            return sides.filter {
//                guard let date = $0.date, let selectedDate = datePicker.selectedDate else { return false }
//                return Calendar.current.isDate(date, inSameDayAs: selectedDate)
//            }
//        }
//        return []
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCollectionViewCell
//            let menuItem = menu[indexPath.row]
//            cell.configure(menuItem)
//            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SideDishCell", for: indexPath) as! SideDishCollectionViewCell
//            let sideDish = sides[indexPath.row]
//            cell.configure(sideDish)
//            return cell
//        default: fatalError("Invalid Section")
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cafeteria?.mealPlans?.count ?? 0
    }
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        collectionView.reloadData()
    }
    
}
