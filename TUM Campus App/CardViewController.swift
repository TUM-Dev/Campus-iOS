//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

class CardViewController: UITableViewController, EditCardsViewControllerDelegate {
    
    var manager: TumDataManager?
    var cards: [DataElement] = []
    var nextLecture: CalendarRow?
    var refresh = UIRefreshControl()
    
    func refresh(_ sender: AnyObject?) {
        manager?.getCardItems().onSuccess { data in
            if self.cards.count <= data.count {
                for item in data {
                    if let movieItem = item as? Movie {
                        movieItem.subscribeToImage(self)
                    }
                    if let lectureItem = item as? CalendarRow {
                        self.nextLecture = lectureItem
                    }
                }
                self.cards = data
                self.tableView.reloadData()
            }
            self.refresh.endRefreshing()
        }
    }
}

extension CardViewController: ImageDownloadSubscriber, DetailViewDelegate {
    
    func updateImageView() {
        tableView.reloadData()
    }
    
    func dataManager() -> TumDataManager? {
        return manager
    }
}

extension CardViewController {
    
    func setupLogo() {
        let bundle = Bundle.main
        let nib = bundle.loadNibNamed("TUMLogoView", owner: nil, options: nil)?.flatMap { $0 as? UIView }
        guard let view = nib?.first else { return }
        self.navigationItem.titleView = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogo()

        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        manager = (self.tabBarController as? CampusTabBarController)?.manager
        refresh(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let navCon = segue.destination as? UINavigationController,
            let mvc = navCon.topViewController as? EditCardsViewController {
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
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cards | indexPath.row ?? EmptyCard()
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(item)
        cell.selectionStyle = .none
		return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

