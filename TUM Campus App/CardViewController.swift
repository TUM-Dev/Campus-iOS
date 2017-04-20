//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit
import FoldingCell

class CardViewController: UITableViewController {
    
    var manager: TumDataManager?
    
    var cards = [DataElement]() {
        didSet {
            kRowsCount = max(cards.count,1)
            createCellHeightsArray()
        }
    }
    
    var nextLecture: CalendarRow?
    
    var refresh = UIRefreshControl()
    
    func refresh(_ sender: AnyObject?) {
            manager?.getCardItems(self)
    }
    
    var cellHeights = [CGFloat]()
    
    let kCloseCellHeight: CGFloat = 108
    let kOpenCellHeight: CGFloat = 408
    var kRowsCount = 4
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
        createCellHeightsArray()
        let logo = UIImage(named: "logo-blue")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        if let bounds = imageView.superview?.bounds {
            imageView.frame = CGRect(x: bounds.origin.x+10, y: bounds.origin.y+10, width: bounds.width-20, height: bounds.height-20)
        }
        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        imageView.clipsToBounds = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
//        tableView.backgroundColor = Constants.backgroundGray
        manager = (self.tabBarController as? CampusTabBarController)?.manager
    }
    
    func createCellHeightsArray() {
        cellHeights = []
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if case let cell as FoldingCell = cell {
            cell.foregroundView.layer.cornerRadius = 8
            cell.foregroundView.layer.masksToBounds = true
            cell.containerView.layer.cornerRadius = 8
            cell.containerView.layer.masksToBounds = true
            if cellHeights[indexPath.row] == kCloseCellHeight {
                cell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                cell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
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
//        cell.defaultColor = tableView.backgroundColor
//        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state1) { (void) in handler() }
//        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state2) { (void) in handler() }
//        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state3) { (void) in handler() }
//        cell.setSwipeGestureWith(UIView(), color: tableView.backgroundColor, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state4) { (void) in handler() }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

