//
//  NewsViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import Alamofire
import FirebaseCrashlytics

@MainActor
class NewsViewModel: ObservableObject {
    @Published var state: APIState<[NewsSource]> = .na
    @Published var hasError: Bool = false
    
    let service: NewsService = NewsService()
    
    func getNewsSources(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            self.state = .success(
                data: try await service.fetch(forcedRefresh: forcedRefresh)
            )
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    var latestFiveNews: [(String?, News?)] {
        guard case .success(let newsSources) = self.state else {
            return []
        }
        
        let latestNews = Array(newsSources
            .map({$0.news})
            .reduce([], +)
            .filter({$0.created != nil && $0.sourceID != 2})
            .sorted(by: {
                guard let date1 = $0.created, let date2 = $1.created else {
                    return false
                }
                return date1.compare(date2) == .orderedDescending
            }).prefix(5))
        
        let latestFiveNews = latestNews.map { news in
            (newsSources.first(where: {$0.id == news.sourceID})?.title, news)
        }
        
        return latestFiveNews
    }
}
