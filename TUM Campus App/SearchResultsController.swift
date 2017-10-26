//
//  SearchResultsController.swift
//  Campus
//
//  Created by Tim Gymnich on 22.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft


class SearchResultsController: UITableViewController {
    
<<<<<<< HEAD:TUM Campus App/SearchViewController.swift
    var promise: Response<[DataElement]>?
    
    weak var delegate: DetailViewDelegate?
    var elements = [DataElement]()
    
    var currentElement: DataElement?
    
    func search(query: String) {
        promise?.cancel()
        promise = delegate?.dataManager()?.search(query: query).onSuccess(in: .main) { data in
            self.elements = data
            self.tableView.reloadData()
        }
    }

}

extension SearchViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return delegate?.dataManager()
=======
    var delegate: DetailViewDelegate?
    var currentElement: DataElement?
    public var elements: [DataElement] = [] {
        didSet {
            tableView.reloadData()
        }
>>>>>>> Tim/RemoveTabBar:TUM Campus App/SearchResultsController.swift
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
            self.tableView.backgroundView = blurEffectView

<<<<<<< HEAD:TUM Campus App/SearchViewController.swift
extension SearchViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != " " {
            let replaced = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if  replaced != "" {
                search(query: replaced)
            } else {
                elements = []
                tableView.reloadData()
            }
        }
        return true
    }
    
}

extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = 102
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
=======
        } else {
            self.view.backgroundColor = .black
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navCon = segue.destination as? UINavigationController {
            if var mvc = navCon.topViewController as? DetailView {
                mvc.delegate = self
            }
            if let mvc = navCon.topViewController as? RoomFinderViewController {
                mvc.room = currentElement
            }
            if let mvc = navCon.topViewController as? PersonDetailTableViewController {
                mvc.user = currentElement
            }
            if let mvc = navCon.topViewController as? LectureDetailsTableViewController {
                mvc.lecture = currentElement
            }
        }
>>>>>>> Tim/RemoveTabBar:TUM Campus App/SearchResultsController.swift
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? RoomFinderViewController {
            mvc.room = currentElement
        }
        if let mvc = segue.destination as? PersonDetailTableViewController {
            mvc.user = currentElement
        }
        if let mvc = segue.destination as? LectureDetailsTableViewController {
            mvc.lecture = currentElement
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentElement = elements[indexPath.row]
        return indexPath
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: elements[indexPath.row].getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(elements[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
}

extension SearchResultsController: TumDataReceiver, ImageDownloadSubscriber {
    
    func receiveData(_ data: [DataElement]) {
        elements = data
        for element in elements {
            if let downloader = element as? ImageDownloader {
                downloader.subscribeToImage(self)
            }
        }
        tableView.reloadData()
    }
    
    func updateImageView() {
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension SearchResultsController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager()
    }
    
}

