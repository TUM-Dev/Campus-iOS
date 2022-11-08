//
//  NewsSource.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 19.01.22.
//

import Alamofire
import Combine
import FirebaseCrashlytics

class NewsSource: Entity, ObservableObject {
    
    typealias ImporterType = Importer<News, [News], JSONDecoder>

    public var id: Int64?
    public var title: String?
    public var icon: URL?
    @Published var news: [News]

    enum CodingKeys: String, CodingKey {
        case id = "source"
        case title = "title"
        case icon = "icon"
    }
    
    init(id: Int64?, title: String?, icon: URL?, news: [News]) {
        self.id = id
        self.title = title
        self.icon = icon
        self.news = news
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
        }
        let title = try container.decode(String.self, forKey: .title)
        let iconString = try container.decode(String.self, forKey: .icon)
        let icon = URL(string: iconString.replacingOccurrences(of: " ", with: "%20"))

        self.id = id
        self.title = title
        self.icon = icon
        self.news = []
        fetchNews()
    }

    func fetchNews() {
        guard let id = self.id else {
            print("NewsSource contain no id")
            return
        }
        
        let endpoint: URLRequestConvertible = TUMCabeAPI.news(source: id.description)
        let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
        let importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: dateDecodingStrategy)
        
        importer.performFetch(handler: { result in
            switch result {
            case .success(let storage):
                self.news = storage.filter( {
                    guard let title = $0.title, let link = $0.link else {
                        return false
                    }
                    return !title.isEmpty && !link.description.isEmpty
                } )
            case .failure(let error):
                print(error)
            }
        })
    }
}
