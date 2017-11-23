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
    
    @IBOutlet var tableView: UITableView!
    
    var manager: TumDataManager?
    var cards: [DataElement] = []
    var categories: [CardCategory] = []
    var nextLecture: CalendarRow?
    var refresh = UIRefreshControl()
    var search: UISearchController?
    
}

extension CardViewController {
    
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
        manager?.loadCards(skipCache: sender != nil).onSuccess(in: .main) { categories in
            // TODO:
            self.cards = categories.flatMap{ $0.elements.first }
            self.categories = categories
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: item.getCellIdentifier()) ?? CardTableViewCell()
        
        if let cell = cell as? SingleDataElementPresentable {
             cell.setElement(item)
        } else if let cell = cell as? MultipleDataElementsPresentable {
            cell.setDataSource(dataSource: self, index: IndexPath(index: indexPath.row))
            cell.collectionView.reloadData()
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
        }
        
        cell.frame = tableView.bounds;
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
		return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension CardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let collectionView = collectionView as? IndexableCollectionView else { fatalError("wrong cell type") }
        guard let index = collectionView.index else { fatalError("missing index property") }
        
        switch index.count {
        case 1: return categories[index[0]].elements.count
        case 2: return categories[index[0]].elements[index[1]].detailElements.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionView = collectionView as? IndexableCollectionView else { fatalError("wrong cell type") }
        guard let index = collectionView.index else { fatalError("missing index property") }

        var item: DataElement {
            switch index.count {
            case 1: return categories[index[0]].elements[indexPath.row]
            case 2: return categories[index[0]].elements[index[1]].detailElements[indexPath.row]
            default: fatalError()
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.getCellIdentifier(), for: indexPath)
        
        if let cell = cell as? SingleDataElementPresentable {
            cell.setElement(item)
        } else if let cell = cell as? MultipleRootDataElementsPresentable {
            cell.setRootElement(item)
            cell.setDataSource(dataSource: self, index: IndexPath(arrayLiteral: index[0], indexPath.row))
            cell.collectionView.reloadData()
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
        } else if let cell = cell as? MultipleDataElementsPresentable {
            cell.setDataSource(dataSource: self, index: IndexPath(arrayLiteral: index[0], indexPath.row))
            cell.collectionView.reloadData()
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
    }
        return cell
    }
}
