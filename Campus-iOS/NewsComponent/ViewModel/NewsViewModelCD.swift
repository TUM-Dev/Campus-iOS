//
//  NewsViewModelCD.swift
//  Campus-iOS
//
//  Created by David Lin on 07.11.22.
//

import Foundation
import CoreData

@MainActor
class NewsViewModelCD: NSObject, ObservableObject {
    
    @Published var newsItemSources = [NewsItemSource]()
    @Published var latestFiveNews: [NewsItem]
    private let context: NSManagedObjectContext
    // https://www.youtube.com/watch?v=gGM_Qn3CUfQ&t=1192s
    private let fetchedResultController: NSFetchedResultsController<NewsItemSource>
    private let model: Model
    
    init(context: NSManagedObjectContext, model: Model) {
        self.context = context
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: NewsItemSource.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.model = model
        
        //---------------------------------------------------
        let latestFiveNewsFetch = NewsItem.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(NewsItem.created), ascending: false)
        latestFiveNewsFetch.sortDescriptors = [sortByDate]
        var fetchedNews = [NewsItem]()
        do {
            fetchedNews = try PersistenceController.shared.container.viewContext.fetch(latestFiveNewsFetch)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        self.latestFiveNews = Array(fetchedNews[...4])
        //---------------------------------------------------
        
        super.init()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
            guard let newsItemSources = fetchedResultController.fetchedObjects else {
                return
            }
            
            self.newsItemSources = newsItemSources
            
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func getNewsItems(for source: NewsItemSource) async {
        do {
            try await TUMCabeAPINew.fetchRelationship(for: [NewsItem].self, into: context, from: Constants.API.TUMCabe.news(String(source.id)), keyPathToParentVariable: #keyPath(NewsItem.newsItemSource), parent: source) { decodedData in
                
                for newsItem in decodedData {
                    newsItem.newsItemSource = source
                    
                }
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    func getNewsItemSources() async {
//        if service.fetchIsNeeded(for: NewsItemSource.self) {
//            self.state = .loading
//            self.hasError = false
        
            do {
//                try await service.fetch(into: context, with: token)
//                self.state = .success
                try await TUMCabeAPINew.fetch(for: [NewsItemSource].self, into: context, from: Constants.API.TUMCabe.newsSources)
            } catch {
//                self.state = .failed(error: error)
//                self.hasError = true
                print(error)
            }
//        }
    }
    
    func fetchLatest5News() -> [NewsItem] {
        let latestFiveNewsFetch = NewsItem.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(NewsItem.created), ascending: false)
        latestFiveNewsFetch.sortDescriptors = [sortByDate]
        var fetchedNews = [NewsItem]()
        do {
            fetchedNews = try PersistenceController.shared.container.viewContext.fetch(latestFiveNewsFetch)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return fetchedNews
    }
}

extension NewsViewModelCD: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let newsItemSources = controller.fetchedObjects as? [NewsItemSource] else {
            return
        }
        
        self.newsItemSources = newsItemSources
//        self.state = .success
    }
}
