//
//  Movie.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

final class Movie: DataElement {
    
    let name: String
    let id: String
    let year: Int
    let runtime: String
    let genre: String
    let director: String
    let actors: String
    let rating: Double
    let description: String
    let created: Date
    let airDate: Date
    let poster: Image
    
    init(name: String,
         id: String,
         year: Int,
         runtime: String,
         rating: Double,
         genre: String,
         actors: String,
         director: String,
         description: String,
         created: Date,
         airDate: Date,
         poster: String) {
        
        self.name = name
        self.id = id
        self.runtime = runtime
        self.director = director
        self.genre = genre
        self.rating = rating
        self.created = created
        self.airDate = airDate
        self.description = description
        self.year = year
        self.actors = actors
        self.poster = .init(url: poster)
    }
    
    func getCellIdentifier() -> String {
        return "film"
    }
    
    var text: String {
        return name.components(separatedBy: ": ")[1] 
    }
    
}

extension Movie: Deserializable {
    
    convenience init?(from json: JSON) {
        
        guard let ratingString = json["rating"].string,
            let rating = Double(ratingString),
            let description = json["description"].string,
            let director = json["director"].string,
            let name = json["title"].string,
            let runtime = json["runtime"].string,
            let airDate = json["date"].date(using: "yyyy-MM-dd HH:mm:ss"),
            let cover = json["cover"].string,
            let created = json["created"].date(using: "yyyy-MM-dd HH:mm:ss"),
            let yearString = json["year"].string,
            let year = Int(yearString),
            let genre = json["genre"].string,
            let id = json["link"].string,
            let actors = json["actors"].string else {
                
            return nil
        }
        
        self.init(name: name,
                  id: id,
                  year: year,
                  runtime: runtime,
                  rating: rating,
                  genre: genre,
                  actors: actors,
                  director: director,
                  description: description,
                  created: created,
                  airDate: airDate,
                  poster: cover)
    }
    
}
