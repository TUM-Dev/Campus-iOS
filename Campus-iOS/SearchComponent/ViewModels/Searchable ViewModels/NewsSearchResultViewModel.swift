//
//  NewsSearchViewModel.swift
//  Campus-iOS
//
//  Created by David Lin on 13.01.23.
//

import Foundation

@MainActor
class NewsSearchResultViewModel: ObservableObject {
    enum VmType {
        case news
        case movie
    }
    
    let vmType : VmType
    ///** The following code is for all newsSources. Currently we only use TUMOnline due to lagginess **
//    @Published var results = [(sourcesResult: NewsSource, distance: Distances)]()
    @Published var newsResults = [(news: News, distance: Distances)]()
    @Published var movieResults = [(movie: Movie, distance: Distances)]()
    private let newsSourceService = NewsSourceService()
    private var newsService: NewsServiceProtocol? = nil
    private var movieService: MovieServiceProtocol? = nil
    
    init(vmType: VmType, newsService: NewsServiceProtocol) {
        self.vmType = vmType
        self.newsService = newsService
    }
    
    init(vmType: VmType, movieService: MovieServiceProtocol) {
        self.vmType = vmType
        self.movieService = movieService
    }
    
    func newsSearch(for query: String) async {
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
        
        switch self.vmType {
        case .news:
            guard let news = await fetchNews(source: "1") else {
                return
            }
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: news) {
                self.newsResults = optionalResults
            }
        case .movie:
            guard let movies = await fetchMovies() else {
                return
            }
            if let optionalResults = GlobalSearch.tokenSearch(for: query, in: movies) {
                self.movieResults = optionalResults
            }
        }
    }
    
//    func fetchNewsSources() async -> [NewsSource]? {
//        do {
//            return try await newsSourceService.fetch(forcedRefresh: false)
//        } catch {
//            print("No news sources were fetched: \(error)")
//            return nil
//        }
//    }
    
    func fetchNews(source: String) async -> [News]? {
        guard let newsService = self.newsService else {
            return nil
        }
        
        do {
            return try await newsService.fetch(forcedRefresh: false, source: source)
        } catch {
            print("No news sources were fetched: \(error)")
            return nil
        }
    }
    
    func fetchMovies() async -> [Movie]? {
        guard let movieService = self.movieService else {
            return nil
        }
        
        do {
            return try await movieService.fetch(forcedRefresh: false)
        } catch {
            print("No news sources were fetched: \(error)")
            return nil
        }
    }
}
