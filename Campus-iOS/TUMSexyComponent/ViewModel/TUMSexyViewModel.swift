//
//  TUMSexyLink.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import Foundation

@MainActor
class TUMSexyViewModel: ObservableObject {
    @Published var state: APIState<[TUMSexyLink]> = .na
    @Published var hasError: Bool = false
    
    let service = TUMSexyService()
    
    func getLinks(forcedRefresh: Bool = false) async {
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
}

//class TUMSexyViewModel: ObservableObject {
//    @Published var links: [TUMSexyLink] = []
//
//    typealias ImporterType = Importer<TUMSexyLink, [String: TUMSexyLink],JSONDecoder>
//    private let importer = ImporterType(endpoint: TUMSexyAPI())
//
//
//    init() {
//        // TODO: Get from cache, if not found, then fetch
//        fetch()
//    }
//
//    func fetch() {
//        importer.performFetch( handler: { result in
//            switch result {
//            case .success(let storage):
//                var filledLinks = [TUMSexyLink]()
//                storage.values.forEach() {
//                    if $0.target != nil && $0.description != nil {
//                        filledLinks.append($0)
//                    }
//                }
//                self.links = filledLinks
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }
//}
