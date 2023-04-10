//
//  MoviesViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import Foundation
import Alamofire
import FirebaseCrashlytics

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var state: APIState<[Movie]> = .na
    @Published var hasError: Bool = false
    
    let service: MoviesService = MoviesService()
    
    func getMovies(forcedRefresh: Bool = false) async {
        if !forcedRefresh {
            self.state = .loading
        }
        self.hasError = false

        do {
            let movies = try await service.fetch(forcedRefresh: forcedRefresh)
            
            self.state = .success(
                data: filterAndSort(for: movies)
            )
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    func filterAndSort(for movies: [Movie]) -> [Movie] {
        let relevantMovies = movies.filter ({
            if let date = $0.date {
                return Date.now <= date
            } else {
                // If no date available keep movie just in case
                return true;
            }
        })
        
        return relevantMovies.sorted(by: {
            guard let dateOne = $0.date, let dateTwo = $1.date else {
                return false
            }
            return dateOne < dateTwo
        })
        
    }
}

//class MoviesViewModel: ObservableObject {
//    
//    @Published var movies = [Movie]()
//    
//    typealias ImporterType = Importer<Movie, [Movie], JSONDecoder>
//    private let sessionManager: Session = Session.defaultSession
//    
//    init() {
//        // TODO: Get from cache, if not found, then fetch
//        fetch()
//    }
//    
//    func fetch() {
//        let endpoint: URLRequestConvertible = TUMCabeAPI.movie
//        let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
//        let importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: dateDecodingStrategy)
//        
//        importer.performFetch(handler: { result in
//            switch result {
//            case .success(let incoming):
//                // Remove all movies from list that are older than today
//                let relevantMovies = incoming.filter ({
//                    if let date = $0.date {
//                        return Date.now <= date
//                    } else {
//                        // If no date available keep movie just in case
//                        return true;
//                    }
//                })
//                
//                self.movies = relevantMovies.sorted(by: {
//                    guard let dateOne = $0.date, let dateTwo = $1.date else {
//                        return false
//                    }
//                    return dateOne < dateTwo
//                })
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }
//}
