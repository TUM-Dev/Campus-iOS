//
//  NewsCollectionViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/2/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData

final class NewsCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout {
    typealias NewsImporter = Importer<News,[News],JSONDecoder>
    typealias MovieImporter = Importer<Movie,[Movie],JSONDecoder>
    
    let newsPredicate = NSPredicate(format: "%K < %d", #keyPath(News.sourceID), 7)
    lazy var newsImporter = NewsImporter(endpoint: TUMCabeAPI.news, predicate: newsPredicate, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    let newsCellIdentifier = "NewsCell"
    
    lazy var newsSourceImporter = Importer<NewsSource,[NewsSource],JSONDecoder>(endpoint: TUMCabeAPI.newsSources, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    let newsspreadPredicate = NSPredicate(format: "%K >= %d", #keyPath(News.sourceID), 7)
    lazy var newsspreadImporter = NewsImporter(endpoint: TUMCabeAPI.news, predicate: newsspreadPredicate, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    let newsspreadCellIdentifier = "NewsspreadCollectionView"
    
    lazy var eventsImporter = TicketImporter(endpoint: TUMCabeAPI.events, sortDescriptor: NSSortDescriptor(keyPath: \TicketEvent.start, ascending: false), dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    let eventCellIdentifier = "EventCollectionView"
    
    lazy var movieImporter: MovieImporter = MovieImporter(endpoint: TUMCabeAPI.movie, sortDescriptor: NSSortDescriptor(keyPath: \Movie.date, ascending: false), dateDecodingStrategy: .formatted(DateFormatter.yyyyMMddhhmmss))
    let movieCelIdentifier = "MovieCollectionView"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsImporter.performFetch()
        newsSourceImporter.performFetch() { error in
            print(error)
        }
        newsImporter.fetchedResultsControllerDelegate = self

        newsspreadImporter.performFetch()
        newsspreadImporter.fetchedResultsControllerDelegate = self

        eventsImporter.performFetch()
        eventsImporter.fetchedResultsControllerDelegate = self

        movieImporter.performFetch()
        movieImporter.fetchedResultsControllerDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! newsImporter.fetchedResultsController.performFetch()
        try! newsspreadImporter.fetchedResultsController.performFetch()
        try! eventsImporter.fetchedResultsController.performFetch()
        try! movieImporter.fetchedResultsController.performFetch()
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return newsImporter.fetchedResultsController.fetchedObjects?.count ?? 0
        case 1: return 1
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellIdentifier, for: indexPath) as! NewsCollectionViewCell
            guard let news = newsImporter.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
            cell.configure(news)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsspreadCellIdentifier, for: indexPath) as! NewsspreadCollectionView
            cell.backgroundColor = .yellow
            cell.news = newsspreadImporter.fetchedResultsController.fetchedObjects ?? []
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellIdentifier, for: indexPath) as! EventsCollectionView
            cell.backgroundColor = .green
            cell.events = eventsImporter.fetchedResultsController.fetchedObjects ?? []
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCelIdentifier, for: indexPath) as! MoviesCollectionView
            cell.movies = movieImporter.fetchedResultsController.fetchedObjects ?? []
            cell.backgroundColor = .blue
            return cell
        default:
            fatalError("Invalid Section")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 3:
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(200))
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(128))
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView.reloadData()
    }
    
}


