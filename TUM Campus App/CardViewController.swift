//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

class CardViewController: UIViewController, UICollectionViewDelegate, TUMDataSourceDelegate, EditCardsViewControllerDelegate, DetailViewDelegate {
    
    @IBOutlet weak var profileButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var manager: TumDataManager?
    var composedDataSource: ComposedDataSource?
    var dataSources: [TUMDataSource] = []
    var cards: [DataElement] = []
    var nextLecture: CalendarRow?
    var refresh = UIRefreshControl()
    var search: UISearchController?
    var logoView: TUMLogoView?
    var binding: ImageViewBinding?
    
    
    //MARK: - UICollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = (self.navigationController as? CampusNavigationController)?.manager
        
        setupCollectionView()
        setupLogo()
        setupSearch()
        
        //        refresh(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        updateProfileButton()
    }
    
    //MARK: - Segue
    
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
    
    //MARK: - Setup UI
    
    func setupLogo() {
        let bundle = Bundle.main
        let nib = bundle.loadNibNamed("TUMLogoView", owner: nil, options: nil)?.flatMap { $0 as? TUMLogoView }
        guard let view = nib?.first else { return }
        logoView = view
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.titleView = view
    }
    
    func setupCollectionView() {
        guard let manager = manager else { return }
        
        composedDataSource = ComposedDataSource(manager: manager)
        composedDataSource?.delegate = self
        collectionView.dataSource = composedDataSource
        composedDataSource?.refresh()
        //        refresh.addTarget(self, action: #selector(CardViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refresh)
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
            fatalError("This doesnt work anymore")
            //            self.tableView.tableHeaderView = search?.searchBar
        }
    }

//    @objc func refresh(_ sender: AnyObject?) {
//        manager?.loadCards(skipCache: sender != nil).onResult(in: .main) { data in
//            self.nextLecture = data.value?.flatMap({ $0 as? CalendarRow }).first
//            self.cards = data.value ?? []
//            self.collectionView.reloadData()
//            self.refresh.endRefreshing()
//        }
//        if manager?.user?.data == nil || sender != nil {
//            manager?.userDataManager.fetch(skipCache: sender != nil).onResult(in: .main) { _ in
//                self.updateProfileButton()
//            }
//        }
//    }
//
    func didUpdateCards() {
//        refresh(nil)
        collectionView.reloadData()
    }
    
    func updateProfileButton() {
        guard let userData = manager?.user?.data else {
            binding = nil
            profileButtonItem.image = #imageLiteral(resourceName: "contact")
            return
        }
        
        binding = userData.avatar.bind(to: profileButtonItem, default: #imageLiteral(resourceName: "contact")) { image in
            let squared = image.squared()
            return squared.withRoundedCorners(radius: squared.size.height / 2.0, borderSize: 0.0)
        }
    }
    
    //MARK: - TUMDataSourceDelegate
    
    func didRefreshDataSources() {
        print("Did Refresh")
        collectionView.reloadData()
    }
    
    func didTimeOutRefreshingDataSource() {
        print("Timeout :(")
        //Handle error load again / Display error message
    }
    
    //MARK: - DetailViewDelegate
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
}
