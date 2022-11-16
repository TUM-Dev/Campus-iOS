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
