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
//    @Published var results = [(sourcesResult: NewsSource, distance: Distances)]()
    @Published var results = [(newsResult: News, distance: Distances)]()
    private let newsSourceService = NewsSourceService()
    private let newsService = NewsService()
    
    func newsSearch(for query: String) async {
        ///** The followin code is for all newsSources. Currently we only use TUMOnline due to lagginess **

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
        
        guard let news = await fetchNews(source: "1") else {
            return
        }
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: news) {
            self.results = optionalResults
        }
    }
    
    func fetchNewsSources() async -> [NewsSource]? {
        do {
            return try await newsSourceService.fetch(forcedRefresh: false)
        } catch {
            print("No news sources were fetched: \(error)")
            return nil
        }
    }
    
    func fetchNews(source: String) async -> [News]? {
        do {
            return try await newsService.fetch(forcedRefresh: false, source: source)
        } catch {
            print("No news sources were fetched: \(error)")
            return nil
        }
    }
}
