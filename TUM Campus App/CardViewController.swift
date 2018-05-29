//
//  ViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import UIKit

class CardViewController: UIViewController, UICollectionViewDelegateFlowLayout, TUMDataSourceDelegate, EditCardsViewControllerDelegate, DetailViewDelegate {

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
    var flowLayout: UICollectionViewFlowLayout?
    var collectionViewSizeChanged: Bool = false
    let margin: CGFloat = 20.0
    
    @objc func refresh(_ sender: AnyObject?) {
        manager?.loadCards(skipCache: sender != nil).onResult(in: .main) { data in
            self.nextLecture = data.value?.flatMap({ $0 as? CalendarRow }).first
            self.cards = data.value ?? []
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
        if manager?.user?.data == nil || sender != nil {
            manager?.userDataManager.fetch(skipCache: sender != nil).onResult(in: .main) { _ in
                self.updateProfileButton()
            }
        }
    }
    
    func didUpdateCards() {
        refresh(nil)
        tableView.reloadData()
    }
    
    func updateProfileButton() {
        if let data = manager?.user?.data {
            binding = data.avatar.bind(to: probileButtonItem, default: #imageLiteral(resourceName: "contact")) { image in
                
                let squared = image.squared()
                return squared.withRoundedCorners(radius: squared.size.height / 2.0, borderSize: 0.0)
            }
        } else {
            binding = nil
            probileButtonItem.image = #imageLiteral(resourceName: "contact")
        }
    }
    
}

extension CardViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
    //MARK: - UICollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = (self.navigationController as? CampusNavigationController)?.manager
        setupCollectionView()
        setupLogo()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        updateProfileButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh(sender: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionViewSizeChanged = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if collectionViewSizeChanged {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionViewSizeChanged {
            collectionViewSizeChanged = false
            collectionView.performBatchUpdates({}, completion: nil)
        }
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
        let nib = bundle.loadNibNamed("TUMLogoView", owner: nil, options: nil)?.compactMap { $0 as? TUMLogoView }
        guard let view = nib?.first else { return }
        logoView = view
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.titleView = view
    }
    
    @objc func refresh(sender: AnyObject?) {
        composedDataSource?.refresh()
        if manager?.user?.data == nil || sender != nil {
            manager?.userDataManager.fetch(skipCache: sender != nil).onResult(in: .main) { _ in
                self.updateProfileButton()
            }
        }
    }
    
    func setupCollectionView() {
        guard let manager = manager else { return }
        
        composedDataSource = ComposedDataSource(manager: manager)
        composedDataSource?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = composedDataSource
        refresh.addTarget(self, action: #selector(CardViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = refresh
        flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        definesPresentationContext = true
    }
    
    func setupFlowLayout() {
        guard let flowLayout = flowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0.0, right: margin)
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
            navigationItem.searchController = search
        }
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
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        guard let composedDataSource = composedDataSource else {
            return CGSize(width: collectionView.frame.size.width, height: 400)
        }
        
        let dataSource = composedDataSource.dataSources.filter {!$0.isEmpty && composedDataSource.cardKeys.contains($0.cardKey)}[indexPath.row]
        
        let height: CGFloat
        let width: CGFloat
        
        if collectionView.traitCollection.userInterfaceIdiom == .phone {
            height = dataSource.preferredHeight
            width = collectionView.frame.size.width
        } else {
            height = 400
            width = floor(collectionView.frame.size.width - 1.0 * margin) / 2
        }
        
        return CGSize(width: width, height: height)
    }
    
    
    //MARK: - TUMDataSourceDelegate
    
    func didBeginRefreshingDataSources() {
        refresh.beginRefreshing()
    }
    
    func didRefreshDataSources() {
        refresh.endRefreshing()
        collectionView.reloadData()
    }
    
    
    //MARK: - DetailViewDelegate
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
    
    //MARK: - EditCardsViewControllerDelegate
    
    func didUpdateCards() {
        refresh(sender: nil)
    }
    
}
