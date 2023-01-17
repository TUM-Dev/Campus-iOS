//
//  MoviesViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import Foundation
import Alamofire
import FirebaseCrashlytics

class MoviesViewModel: ObservableObject {
    
    @Published var movies = [Movie]()
    @Published var state: State = .loading
    
    typealias ImporterType = Importer<Movie, [Movie], JSONDecoder>
    private let sessionManager: Session = Session.defaultSession
    
    init() {
        // TODO: Get from cache, if not found, then fetch
        fetch()
    }
    
    func fetch() {
        let endpoint: URLRequestConvertible = TUMCabeAPI.movie
        let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .formatted(.yyyyMMddhhmmss)
        let importer = ImporterType(endpoint: endpoint, dateDecodingStrategy: dateDecodingStrategy)
        
        importer.performFetch(handler: { result in
            switch result {
            case .success(let incoming):
                // Remove all movies from list that are older than today
                let relevantMovies = incoming.filter ({
                    if let date = $0.date {
                        return Date.now <= date
                    } else {
                        // If no date available keep movie just in case
                        return true;
                    }
                })
                
                self.movies = relevantMovies.sorted(by: {
                    guard let dateOne = $0.date, let dateTwo = $1.date else {
                        return false
                    }
                    return dateOne < dateTwo
                })
                
                if self.movies.isEmpty {
                    self.state = .noMovies
                }
                
                self.state = .success
            
            case .failure(let error):
                print(error)
                self.state = .failed
            }
        })
    }
}

extension MoviesViewModel {
    enum State {
        case loading
        case success
        case failed
        case noMovies
    }
}
