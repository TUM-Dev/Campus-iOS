//
//  NewsViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import Alamofire
import FirebaseCrashlytics

@MainActor
class NewsViewModel2: ObservableObject {
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


@MainActor
class NewsViewModel: ObservableObject {

    @Published var newsSources = [NewsSource]()
    @Published var news = [News]()
    @Published var sourcesAndNews = [(Int64?, [News])]()
    //@Published var news = [News]()
    
    private let sessionManager: Session = Session.defaultSession
    
    init() {
        // TODO: Get from cache, if not found, then fetch
        
        fetch()
//        fetchNews(sourceId: 1)
    }
    
    var latestFiveNews: [(String?, News?)] {
        print(">> latestFiveNews loaded")
        let latestNews = Array(self.newsSources
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
    
    func fetch() {
        typealias ImporterType = Importer<NewsSource, [NewsSource], JSONDecoder>
        
        let endpoint: URLRequestConvertible = TUMCabeAPI.newsSources
        let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
        let importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: dateDecodingStrategy)
        
        importer.performFetch(handler: { result in
            switch result {
            case .success(let incoming):
                incoming.forEach { newsSource in
                    self.fetchNews(sourceId: newsSource.id)
                }
                
                self.newsSources = incoming
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchNews(sourceId: Int64?) {
        typealias ImporterTypeNews = Importer<News, [News], JSONDecoder>

        guard let id = sourceId else {
            print("NewsSource contains no id")
            return
        }

        let endpointNews: URLRequestConvertible = TUMCabeAPI.news(source: id.description)
        let dateDecodingStrategyNews: JSONDecoder.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
        let importerNews = ImporterTypeNews(endpoint: endpointNews, dateDecodingStrategy: dateDecodingStrategyNews)

        importerNews.performFetch(handler: { result in
            switch result {
            case .success(let storage):
                let news = storage.filter( {
                    guard let title = $0.title, let link = $0.link else {
                        return false
                    }
                    return !title.isEmpty && !link.description.isEmpty
                } )
                self.sourcesAndNews.append((sourceId, news))
            case .failure(let error):
                print(error)
            }
        })
    }

    
}

class MockNewsViewModel: NewsViewModel {
    
    static let mockNewsA = News(id: "1", sourceId: 1, date: Date(), created: Date(), title: "Dummy Title", link: URL(string: "https://github.com/orgs/TUM-Dev"), imageURL: "https://app.tum.de/File/news/newspread/dab04abdf3954d3e1bf56cef44d68662.jpg")
    static let mockNewsB = News(id: "3", sourceId: 3, date: Date(), created: Date(), title: "Dummy Title", link: URL(string: "https://github.com/orgs/TUM-Dev"), imageURL: "https://app.tum.de/File/news/newspread/dab04abdf3954d3e1bf56cef44d68662.jpg")

    static let newsSourceA = NewsSource(id: 1, title: "TUM News A", icon: nil, news: [mockNewsA, mockNewsA, mockNewsA])
    static let newsSourceB = NewsSource(id: 3, title: "TUM News B", icon: nil, news: [mockNewsB, mockNewsB, mockNewsB])
    
    let mockNewsSources = [newsSourceA, newsSourceB]
    
    
    override func fetch() {
        self.newsSources = mockNewsSources
    }
}
