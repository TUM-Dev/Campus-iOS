//
//  TUMSexyLink.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import UIKit

struct TUMSexyLink: Entity {
    var description: String?
    var target: String?
    var moodleID: String?
}

class TUMSexyViewModel: ObservableObject {
    @Published var links: [TUMSexyLink] = []
    
    typealias ImporterType = Importer<TUMSexyLink, [String: TUMSexyLink],JSONDecoder>
    private let importer = ImporterType(endpoint: TUMSexyAPI())

    
    init() {
        // TODO: Get from cache, if not found, then fetch
        fetch()
    }
    
    func fetch() {
        importer.performFetch( handler: { result in
            switch result {
            case .success(let storage):
                var filledLinks = [TUMSexyLink]()
                storage.values.forEach() {
                    if $0.target != nil && $0.description != nil {
                        filledLinks.append($0)
                    }
                }
                self.links = filledLinks
            case .failure(let error):
                print(error)
            }
        })
    }
}
