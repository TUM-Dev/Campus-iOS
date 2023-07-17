//
//  NewsSource.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 19.01.22.
//

import Alamofire
import Combine
import FirebaseCrashlytics

struct NewsSource: Decodable, Identifiable, Searchable {
    static func == (lhs: NewsSource, rhs: NewsSource) -> Bool {
        return lhs.id == rhs.id
    }
    
    var comparisonTokens: [ComparisonToken] {
        return [ComparisonToken(value: title ?? "")] + news.flatMap({$0.comparisonTokens})
    }
    
    var id: Int64?
    var title: String?
    var icon: URL?
    var news: [News]
    
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

    init(from decoder: Decoder) throws {
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
    }
}

extension NewsSource {
    static let previewData: [NewsSource] = [
        NewsSource(id: 12, title: "TUMNews", icon: nil, news: News.previewData)
    ]
}
