//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

class CardViewController: UIViewController {
    
    var manager: TumDataManager?
    var cards: [DataElement] = []
    var nextLecture: CalendarRow?
    var refresh = UIRefreshControl()
    var search: UISearchController?
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogo()
        setupTableView()
        setupSearch()
        
        manager = (self.navigationController as? CampusNavigationController)?.manager
        refresh(nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
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
    
    func setupLogo() {
        let bundle = Bundle.main
        let nib = bundle.loadNibNamed("TUMLogoView", owner: nil, options: nil)?.flatMap { $0 as? UIView }
        guard let view = nib?.first else { return }
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        self.navigationItem.titleView = view
    }
    
    func setupTableView() {
        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        definesPresentationContext = true
    }
    
    func setupSearch() {
        let storyboard = UIStoryboard(name: "CardView", bundle: nil)
        guard let searchResultsController = storyboard.instantiateViewController(withIdentifier: "SearchResultsController") as? SearchResultsController else {
            fatalError("Unable to instatiate a SearchResultsViewController from the storyboard.")
        }
        searchResultsController.delegate = self
        searchResultsController.navCon = self.navigationController
        search = UISearchController(searchResultsController: searchResultsController)
        search?.searchResultsUpdater = searchResultsController
        search?.searchBar.placeholder = "Search"
        search?.obscuresBackgroundDuringPresentation = true
        search?.hidesNavigationBarDuringPresentation = true
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = search
        } else {
            self.tableView.tableHeaderView = search?.searchBar
        }
    }
    
}

extension CardViewController: EditCardsViewControllerDelegate {
    
    func refresh(_ sender: AnyObject?) {
        manager?.loadCards(skipCache: sender != nil).onSuccess(in: .main) { data in
            self.nextLecture = data.flatMap({ $0 as? CalendarRow }).first
            self.cards = data
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    func didUpdateCards() {
        refresh(nil)
        tableView.reloadData()
    }
}


extension CardViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
}


extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(cards.count, 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cards | indexPath.row ?? EmptyCard()
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(item)
        cell.selectionStyle = .none
		return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


extension CardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return cards[collectionView.tag].count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
}


