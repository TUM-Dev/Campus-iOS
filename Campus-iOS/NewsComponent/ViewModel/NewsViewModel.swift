////
////  NewsViewModel.swift
////  Campus-iOS
////
////  Created by Milen Vitanov on 13.01.22.
////
//
//import Alamofire
//import FirebaseCrashlytics
//import Combine
//
//struct NewsSource: Entity {
//
//    var id: Int64?
//    var title: String?
//    var icon: URL?
//    var news: [News]
//
//    enum CodingKeys: String, CodingKey {
//        case id = "source"
//        case title = "title"
//        case icon = "icon"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let idString = try container.decode(String.self, forKey: .id)
//        guard let id = Int64(idString) else {
//            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
//        }
//        let title = try container.decode(String.self, forKey: .title)
//        let iconString = try container.decode(String.self, forKey: .icon)
//        let icon = URL(string: iconString.replacingOccurrences(of: " ", with: "%20"))
//
//        self.id = id
//        self.title = title
//        self.icon = icon
//        self.news = NSSet(array: news)
//    }
//
//    func fetchNews() {
//
//    }
//
//    typealias EntityType = News
//    typealias EntityContainer = [News]
//    typealias DecoderType = JSONDecoder
//    typealias ErrorHandler = (Error) -> Void
//    typealias SuccessHandler = () -> Void
//
//    typealias RequestHandler = (Result<[News], Error>) -> Void
//
//    private let sessionManager: Session = Session.defaultSession
//
//    func performFetch(handler: RequestHandler? = nil) {
//
//        guard let id = self.id else {
//            handler?(.failure(ImporterError.invalidData))
//            return
//        }
//
//        let endpoint: URLRequestConvertible = TUMCabeAPI.news(source: id.description)
//        let dateDecodingStrategy: DecoderType.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
//
//        sessionManager.request(endpoint)
//            .validate(statusCode: 200..<300)
//            .validate(contentType: DecoderType.contentType)
//            .responseData { response in
//                if let responseError = response.error {
//                    handler?(.failure(BackendError.AFError(message: responseError.localizedDescription)))
//                    return
//                }
//                guard let data = response.data else {
//                    handler?(.failure(ImporterError.invalidData))
//                    return
//                }
//                let decoder = DecoderType.instantiate()
//                if let strategy = self.dateDecodingStrategy {
//                    decoder.dateDecodingStrategy = strategy
//                }
//                let group = DispatchGroup()
//                do {
//                    let sources = try decoder.decode([NewsSource].self, from: data)
//                    sources.forEach {
//                        group.enter()
//                        let endpoint = TUMCabeAPI.news(source: $0.source)
//                        self.sessionManager.request(endpoint)
//                            .validate(statusCode: 200..<300)
//                            .validate(contentType: DecoderType.contentType)
//                            .responseData { response in
//                                defer { group.leave() }
//                                guard let data = response.data else { return }
//                                let decoder = DecoderType.instantiate()
//                                decoder.userInfo[.context] = self.context
//                                if let strategy = self.dateDecodingStrategy {
//                                    decoder.dateDecodingStrategy = strategy
//                                }
//                                _ = try? decoder.decode([News].self, from: data)
//                        }
//                    }
//                } catch let apiError as APIError {
//                    Crashlytics.crashlytics().record(error: apiError)
//                    errorHandler?(apiError)
//                    return
//                } catch let decodingError as DecodingError {
//                    Crashlytics.crashlytics().record(error: decodingError)
//                    errorHandler?(decodingError)
//                    return
//                } catch let error {
//                    Crashlytics.crashlytics().record(error: error)
//                    fatalError(error.localizedDescription)
//                }
//                group.notify(queue: .main) {
//                    try? self.context.save()
//                    successHandler?()
//                }
//        }
//    }
//}
//
//struct News: Entity {
//    var id: String?
//    var sourceID: Int64
//    var date: Date?
//    var created: Date?
//    var title: String?
//    var link: URL?
//    var imageURL: URL?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "news"
//        case sourceID = "src"
//        case date = "date"
//        case created = "created"
//        case title = "title"
//        case link = "link"
//        case imageURL = "image"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let id = try container.decode(String.self, forKey: .id)
//        let sourceString = try container.decode(String.self, forKey: .sourceID)
//        guard let sourceID = Int64(sourceString) else {
//            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for source could not be converted to Int64"))
//        }
//        let date = try container.decode(Date.self, forKey: .date)
//        let created = try container.decode(Date.self, forKey: .created)
//        let title = try container.decode(String.self, forKey: .title)
//        let link = try container.decode(URL.self, forKey: .link)
//        let imageURLString = try container.decode(String.self, forKey: .imageURL)
//        let imageURL = URL(string: imageURLString.replacingOccurrences(of: " ", with: "%20"))
//
//        self.id = id
//        self.sourceID = sourceID
//        self.date = date
//        self.created = created
//        self.title = title
//        self.link = link
//        self.imageURL = imageURL
//    }
//}
//
//class NewsViewModel: ObservableObject {
//
//    @Published var newsSources = [NewsSource: [News]]()
//
//    typealias EntityType = NewsSource
//    typealias EntityContainer = [NewsSource]
//    typealias DecoderType = JSONDecoder
//    typealias ErrorHandler = (Error) -> Void
//    typealias SuccessHandler = () -> Void
//
//    typealias RequestHandler = (Result<[NewsSource], Error>) -> Void
//
//    private let sessionManager: Session = Session.defaultSession
//
//    let endpoint: URLRequestConvertible = TUMCabeAPI.newsSources
//    let dateDecodingStrategy: DecoderType.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
//
//    func performFetch(handler: RequestHandler? = nil) {
//        sessionManager.request(endpoint)
//            .validate(statusCode: 200..<300)
//            .validate(contentType: DecoderType.contentType)
//            .responseData { response in
//                if let responseError = response.error {
//                    handler?(.failure(BackendError.AFError(message: responseError.localizedDescription)))
//                    return
//                }
//                guard let data = response.data else {
//                    handler?(.failure(ImporterError.invalidData))
//                    return
//                }
//                let decoder = DecoderType.instantiate()
//                if let strategy = self.dateDecodingStrategy {
//                    decoder.dateDecodingStrategy = strategy
//                }
//                let group = DispatchGroup()
//                do {
//                    let sources = try decoder.decode([NewsSource].self, from: data)
//                    sources.forEach {
//                        group.enter()
//                        let endpoint = TUMCabeAPI.news(source: $0.source)
//                        self.sessionManager.request(endpoint)
//                            .validate(statusCode: 200..<300)
//                            .validate(contentType: DecoderType.contentType)
//                            .responseData { response in
//                                defer { group.leave() }
//                                guard let data = response.data else { return }
//                                let decoder = DecoderType.instantiate()
//                                decoder.userInfo[.context] = self.context
//                                if let strategy = self.dateDecodingStrategy {
//                                    decoder.dateDecodingStrategy = strategy
//                                }
//                                _ = try? decoder.decode([News].self, from: data)
//                        }
//                    }
//                } catch let apiError as APIError {
//                    Crashlytics.crashlytics().record(error: apiError)
//                    errorHandler?(apiError)
//                    return
//                } catch let decodingError as DecodingError {
//                    Crashlytics.crashlytics().record(error: decodingError)
//                    errorHandler?(decodingError)
//                    return
//                } catch let error {
//                    Crashlytics.crashlytics().record(error: error)
//                    fatalError(error.localizedDescription)
//                }
//                group.notify(queue: .main) {
//                    try? self.context.save()
//                    successHandler?()
//                }
//        }
//    }
//}
