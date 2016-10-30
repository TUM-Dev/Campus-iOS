//
//  MovieManager.swift
//  
//
//  Created by Mathias Quintero on 12/6/15.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieManager: Manager {
    
    static var movies = [Movie]()
    
    var single = false
    
    required init(mainManager: TumDataManager) {
        
    }
    
    init(single: Bool) {
        self.single = single
    }
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if MovieManager.movies.isEmpty {
            if let request = getRequest() {
                Alamofire.request(request as! URLRequestConvertible).responseJSON() { (response) in
                    if let data = response.result.value {
                        if let json = JSON(data).array {
                            for item in json {
                                if let rating = item["rating"].string, let description = item["description"].string, let director = item["director"].string, let name = item["title"].string, let runtime = item["runtime"].string, let date = item["date"].string, let cover = item["cover"].string, let created = item["created"].string, let year = item["year"].string, let genre = item["genre"].string, let id = item["link"].string, let actors = item["actors"].string {
                                    let runTimeAsNumber = Int(runtime.components(separatedBy: " ")[0]) ?? 0
                                    let ratingAsNumber = Double(rating) ?? 0.0
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    
                                    let poster = cover.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                                    let creationDate = dateFormatter.date(from: created) ?? Date()
                                    let airdate = dateFormatter.date(from: date) ?? Date()
                                    let yearAsNumber = Int(year) ?? 0
                                    let movie = Movie(name: name, id: id, year: yearAsNumber, runtime: runTimeAsNumber, rating: ratingAsNumber, genre: genre, actors: actors, director: director, description: description, created: creationDate, airDate: airdate, poster: poster)
                                    MovieManager.movies.append(movie)
                                }
                            }
                            self.handleMovies(handler)
                        }
                    }
                }
            }
        } else {
            handleMovies(handler)
        }
        
    }
    
    func handleMovies(_ handler: ([DataElement]) -> ()) {
        let onlyNew = MovieManager.movies.filter() { (movie) in
            return movie.airDate.compare(Date()) == ComparisonResult.orderedDescending
        }
        if single {
            if !onlyNew.isEmpty {
                handler([onlyNew[0]])
            }
            
        } else {
            var returnableArray = [DataElement]()
            for item in onlyNew {
                returnableArray.append(item)
            }
            handler(returnableArray)
        }
    }
    
    func getURL() -> String {
        return TumCabeApi.BaseURL.rawValue + TumCabeApi.Movie.rawValue
    }
    
    func getRequest() -> NSMutableURLRequest? {
        if let url = URL(string: getURL()), let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(uuid, forHTTPHeaderField: "X-DEVICE-ID")
            return request
        }
        return nil
    }
    
}
