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
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if MovieManager.movies.isEmpty {
            if let request = getRequest() {
                Alamofire.request(request).responseJSON() { (response) in
                    if let data = response.result.value {
                        if let json = JSON(data).array {
                            for item in json {
                                if let rating = item["rating"].string, description = item["description"].string, director = item["director"].string, name = item["title"].string, runtime = item["runtime"].string, date = item["date"].string, cover = item["cover"].string, created = item["created"].string, year = item["year"].string, genre = item["genre"].string, id = item["link"].string, actors = item["actors"].string {
                                    let runTimeAsNumber = Int(runtime.componentsSeparatedByString(" ")[0]) ?? 0
                                    let ratingAsNumber = Double(rating) ?? 0.0
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    let poster = cover.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()) ?? ""
                                    let creationDate = dateFormatter.dateFromString(created) ?? NSDate()
                                    let airdate = dateFormatter.dateFromString(date) ?? NSDate()
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
    
    func handleMovies(handler: ([DataElement]) -> ()) {
        let onlyNew = MovieManager.movies.filter() { (movie) in
            return movie.airDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
        }
        if single {
            if !onlyNew.isEmpty {
                handler([onlyNew[0]])
            }
            
        } else {
            handler(onlyNew as [DataElement])
        }
    }
    
    func getURL() -> String {
        return TumCabeApi.BaseURL.rawValue + TumCabeApi.Movie.rawValue
    }
    
    func getRequest() -> NSMutableURLRequest? {
        if let url = NSURL(string: getURL()), let uuid = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.setValue(uuid, forHTTPHeaderField: "X-DEVICE-ID")
            return request
        }
        return nil
    }
    
}