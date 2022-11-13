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
    
    private let context: NSManagedObjectContext
    // https://www.youtube.com/watch?v=gGM_Qn3CUfQ&t=1192s
    private let fetchedResultController: NSFetchedResultsController<NewsItemSource>
    private let model: Model
    
    init(context: NSManagedObjectContext, model: Model) {
        self.context = context
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: NewsItemSource.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.model = model
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
        print(source.title)
        
//            let deletRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NewsItem")
//            deletRequest.predicate = NSPredicate(format: "newsItemSource == %@", source)
//            let storedNewsItemsOptional = source.newsItems?.allObjects as? [NewsItem]
////            source.removeFromNewsItems(...)
        ///
        
        do {
            if let storedNewsItems = source.newsItems?.allObjects as? [NewsItem] {
                for newsItem in storedNewsItems {
                    print(newsItem)
                    source.removeFromNewsItems(newsItem)
                    context.delete(newsItem)
                }
            }
            
            let newNewsItems = try await TUMCabeAPINew.fetchNewsItems(into: context, from: Constants.API.TUMCabe.news(String(source.id)))
            
            
            for newsItem in newNewsItems {
                print(newsItem)
                source.addToNewsItems(newsItem)
            }
            
        } catch {
            print(String(describing: error))
        }
        
        do {
            try context.save()
        } catch {
            print(String(describing: error))
        }
            
//            for newsItem in newNewsItems {
//                source.
//            }
//            { fetchedNewsItems in
//                fetchedNewsItems.forEach { newsItem in
//                    
//                    if let storedNewsItems = storedNewsItemsOptional,
//                        storedNewsItems.contains(where: {$0 == newsItem}) {
//                       
//                        context.delete(newsItem)
//                    } else {
//                        newsItem.newsItemSource = source
//                    }
//                    
//                    //Delete if already in source.newsItems otherwise they will be added or manually deletion is needed.
//                    
//                    
////
//                }
////                do {
////                    try context.save()
////                } catch {
////                    print(error)
////                }
//            }
        
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
