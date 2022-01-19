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
    
    func fetch() {
        let endpoint: URLRequestConvertible = TUMCabeAPI.newsSources
        let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
        let importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: dateDecodingStrategy)
        
        importer.performFetch(handler: { result in
            switch(result) {
            case .success(let incoming):
                self.newsSources = incoming
            case .failure(let error):
                print(error)
            }
        })
    }

    
}
