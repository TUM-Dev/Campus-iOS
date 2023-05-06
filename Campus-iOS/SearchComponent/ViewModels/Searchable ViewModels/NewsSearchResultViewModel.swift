//
//  NewsSearchViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

@MainActor
class NewsSearchResultViewModel: ObservableObject {
    ///** The following code is for all newsSources. Currently we only use TUMOnline due to lagginess **
//    @Published var state: SearchState<NewsSource> = .na
    @Published var state: SearchState<News> = .na
    @Published var hasError: Bool = false
    
    let service: NewsServiceProtocol
    
    init(service: NewsServiceProtocol) {
        self.service = service
    }
    
    func newsSearch(for query: String, forcedRefresh: Bool = false) async {
        ///** The following code is for all newsSources. Currently we only use TUMOnline due to lagginess **

//        guard let newsSources = await fetchNewsSources() else {
//            return
//        }
//
//        var sources = [NewsSource]()
//        for newsSource in newsSources {
//            if let id = newsSource.id {
//                if let news = await fetchNews(source: String(id)) {
//                    sources.append(NewsSource(id: newsSource.id, title: newsSource.title, icon: newsSource.icon, news: news))
//                    print(news)
//                }
//            }
//        }
        
//        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: sources) {
//            self.results = optionalResults
//        }
        
        
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            let data = try await service.fetch(forcedRefresh: forcedRefresh, source: "1")
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: data) {
                self.state = .success(data: optionalResults)
            } else {
                self.state = .failed(error: SearchError.empty(searchQuery: query))
                self.hasError = true
            }
            
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
