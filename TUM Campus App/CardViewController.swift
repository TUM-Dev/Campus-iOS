//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit
import MCSwipeTableViewCell

class CardViewController: UITableViewController {
    
    var manager: TumDataManager?
    
    var cards = [DataElement]()
    
    var nextLecture: CalendarRow?
    
    var refresh = UIRefreshControl()
    
    func refresh(_ sender: AnyObject?) {
        manager?.getCardItems(self)
    }
    
}

extension CardViewController: ImageDownloadSubscriber, DetailViewDelegate {
    
    func updateImageView() {
        tableView.reloadData()
    }
    
    func dataManager() -> TumDataManager {
        return manager ?? TumDataManager(user: nil)
    }
    
}

extension CardViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        if cards.count <= data.count {
            for item in data {
                if let movieItem = item as? Movie {
                    movieItem.subscribeToImage(self)
                }
                if let lectureItem = item as? CalendarRow {
                    nextLecture = lectureItem
                }
            }
            cards = data
            tableView.reloadData()
        }
        refresh.endRefreshing()
    }
    
}

extension CardViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "logo-blue")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        if let bounds = imageView.superview?.bounds {
            imageView.frame = CGRect(x: bounds.origin.x+10, y: bounds.origin.y+10, width: bounds.width-20, height: bounds.height-20)
        }
        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        imageView.clipsToBounds = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = Constants.backgroundGray
        manager = (self.tabBarController as? CampusTabBarController)?.manager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cards.removeAll()
        refresh(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? CalendarViewController {
            mvc.nextLectureItem = nextLecture
        }
    }
    
}

extension CardViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(cards.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cards | indexPath.row ?? EmptyCard()
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(item)
        let handler = { () -> () in
            if let path = self.tableView.indexPath(for: cell) {
                PersistentCardOrder.value.remove(cardFor: item)
                if !self.cards.isEmpty {
                    self.cards.remove(at: path.row)
                }
                if !self.cards.isEmpty {
                    self.tableView.deleteRows(at: [path], with: UITableViewRowAnimation.top)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
        cell.selectionStyle = .none
        cell.defaultColor = tableView.backgroundColor
        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state1) { (void) in handler() }
        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state2) { (void) in handler() }
        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state3) { (void) in handler() }
        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state4) { (void) in handler() }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

