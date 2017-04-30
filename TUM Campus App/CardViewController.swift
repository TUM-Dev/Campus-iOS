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
    var cards: [DataElement] = []
    var nextLecture: CalendarRow?
    var refresh = UIRefreshControl()
    var cellHeights: [CGFloat] = [120]
    var openCellHeights: [CGFloat] = [420]
    var closeCellHeights: [CGFloat] = [120]

    
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
            createCellHeightsArray()
            tableView.reloadData()
        }
        refresh.endRefreshing()
    }
}

extension CardViewController: TableViewCellDelegate {
    
    func cardDeleted(card: FoldingCell) {
        
        if let indexPath = tableView.indexPath(for: card) {
        
            tableView.beginUpdates()
            cards.remove(at: indexPath.row)
            cellHeights.remove(at: indexPath.row)
            closeCellHeights.remove(at: indexPath.row)
            openCellHeights.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
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
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
        tableView.addGestureRecognizer(longpress)
        tableView.addSubview(refresh)
        imageView.clipsToBounds = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.backgroundGray
        manager = (self.tabBarController as? CampusTabBarController)?.manager
    }
    
    
    func longPressGesture(sender: UIGestureRecognizer) {
        let longPress = sender as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        var indexPath = tableView.indexPathForRow(at: locationInView)
    
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Cell.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!)!
                Cell.cellSnapshot  = snapshotOfCell(inputView: cell)
                var center = cell.center
                Cell.cellSnapshot!.center = center
                Cell.cellSnapshot!.alpha = 0.0
                tableView.addSubview(Cell.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    Cell.cellSnapshot!.center = center
                    Cell.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    Cell.cellSnapshot!.alpha = 0.80
                    cell.alpha = 0.0
                   
                }, completion: { (finished) -> Void in
                    if finished {
                        cell.isHidden = true
                    }
                })
            }
            
        case UIGestureRecognizerState.changed:
            var center = Cell.cellSnapshot!.center
            center.y = locationInView.y
            Cell.cellSnapshot!.center = center
            if indexPath != nil && indexPath != Cell.initialIndexPath {
                swap(&cards[indexPath!.row], &cards[Cell.initialIndexPath!.row])
                swap(&cellHeights[indexPath!.row], &cellHeights[Cell.initialIndexPath!.row])
                swap(&openCellHeights[indexPath!.row], &openCellHeights[Cell.initialIndexPath!.row])
                swap(&closeCellHeights[indexPath!.row], &closeCellHeights[Cell.initialIndexPath!.row])
                tableView.moveRow(at: Cell.initialIndexPath!, to: indexPath!)
                Cell.initialIndexPath = indexPath
            }
            
        default:
            let cell = tableView.cellForRow(at: Cell.initialIndexPath!)!
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                Cell.cellSnapshot!.center = cell.center
                Cell.cellSnapshot!.transform = CGAffineTransform.identity
                Cell.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Cell.initialIndexPath = nil
                    Cell.cellSnapshot!.removeFromSuperview()
                    Cell.cellSnapshot = nil
                }
            })
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4

    
        return cellSnapshot
        }
        
    func createCellHeightsArray() {
        cellHeights = []
        closeCellHeights = []
        openCellHeights = []
        
        for card in cards {
            cellHeights.append(card.getCloseCellHeight()+8)
            openCellHeights.append(card.getOpenCellHeight()+8)
            closeCellHeights.append(card.getCloseCellHeight()+8)
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
            if cellHeights[indexPath.row] == closeCellHeights[indexPath.row] {
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
        if cellHeights[indexPath.row] == closeCellHeights[indexPath.row] { // open cell
            cellHeights[indexPath.row] = openCellHeights[indexPath.row]
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = closeCellHeights[indexPath.row]
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
        cell.delegate = self
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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

struct Cell {
    static var cellSnapshot : UIView? = nil
    static var initialIndexPath : IndexPath? = nil
}
