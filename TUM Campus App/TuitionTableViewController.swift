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

class TuitionTableViewController: UITableViewController, DetailView {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
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

extension TuitionTableViewController: TUMPickerControllerDelegate {
    
    func setUpPickerView() {
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(TuitionTableViewController.showSemesters(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func showSemesters(_ send: AnyObject?) {
        let pickerView = TUMPickerController(elements: semesters, selected: currentSemester, delegate: self)
        present(pickerView, animated: true)
    }
    
    func didSelect(element: Tuition) {
        currentSemester = element
    }
    
}
