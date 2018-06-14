//
//  TuitionTableViewController.swift
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
import AYSlidingPickerView

class TuitionTableViewController: UITableViewController, DetailView {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    var pickerView = AYSlidingPickerView()
    var barItem: UIBarButtonItem?
    
    weak var delegate: DetailViewDelegate?
    
    var semesters = [Tuition]()
    
    var currentSemester: Tuition? {
        didSet {
            if let semester = currentSemester {
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MMM dd, yyyy"
                deadLineLabel.text = dateformatter.string(from: semester.frist as Date)
                balanceLabel.text = String(format: "%.2f", semester.soll) + " €"
                title = semester.semester
            }
        }
    }

}

extension TuitionTableViewController {
    
    func fetch() {
        delegate?.dataManager()?.tuitionManager.fetch().onSuccess(in: .main) { semesters in
            self.semesters = semesters
            self.currentSemester = semesters.first
            self.setUpPickerView()
        }
    }
    
}

extension TuitionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
}

extension TuitionTableViewController {
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for semester in semesters {
            let item = AYSlidingPickerViewItem(title: semester.semester) { (did) in
                if did {
                    self.currentSemester = semester
                    self.barItem?.action = #selector(TuitionTableViewController.showSemesters(_:))
                    self.barItem?.image = UIImage(named: "expand")
                    self.tableView.reloadData()
                }
            }
            items.append(item!)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.items = items
        pickerView.mainView = navigationController?.view ?? view
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        pickerView.didDismissHandler = { self.hideSemesters(nil) }
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(TuitionTableViewController.showSemesters(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func showSemesters(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(TuitionTableViewController.hideSemesters(_:))
        barItem?.image = UIImage(named: "collapse")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func hideSemesters(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(TuitionTableViewController.showSemesters(_:))
        barItem?.image = UIImage(named: "expand")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}
