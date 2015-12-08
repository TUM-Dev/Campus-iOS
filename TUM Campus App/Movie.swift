//
//  Movie.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class Movie:ImageDownloader, DataElement {
    
    let name: String
    let id: String
    let year: Int
    let runtime: Int
    let genre: String
    let director: String
    let actors: String
    let rating: Double
    let description: String
    let created: NSDate
    let airDate: NSDate
    
    init(name: String, id: String, year: Int, runtime: Int, rating: Double, genre: String, actors: String, director: String, description: String, created: NSDate, airDate: NSDate, poster: String) {
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
        super.init(url: poster)
    }
    
    func getCellIdentifier() -> String {
        return "film"
    }
    
    var text: String {
        return name
    }
    
    
}
