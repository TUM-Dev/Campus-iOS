//
//  NewsViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import Alamofire
import FirebaseCrashlytics

class NewsViewModel: ObservableObject {

    @Published var newsSources = [NewsSource]()
    
    typealias ImporterType = Importer<NewsSource, [NewsSource], JSONDecoder>
    private let sessionManager: Session = Session.defaultSession
    
    init() {
        // TODO: Get from cache, if not found, then fetch
        
        fetch()
    }
    
    var latestFiveNews: [(String?, News?)] {
        let latestNews = self.newsSources
            .map({$0.news})
            .reduce([], +)
            .filter({$0.created != nil && $0.sourceID != 2})
            .sorted(by: {
                guard let date1 = $0.created, let date2 = $1.created else {
                    return false
                }
                return date1.compare(date2) == .orderedDescending
            })[...4]
        
        let latestFiveNews = latestNews.map { news in
            (newsSources.first(where: {$0.id == news.sourceID})?.title, news)
        }
        
        return latestFiveNews
    }
    
    func fetch() {
        let endpoint: URLRequestConvertible = TUMCabeAPI.newsSources
        let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
        let importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: dateDecodingStrategy)
        
        importer.performFetch(handler: { result in
            switch result {
            case .success(let incoming):
                self.newsSources = incoming
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
