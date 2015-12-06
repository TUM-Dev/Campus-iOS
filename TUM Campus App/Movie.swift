//
//  Movie.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class Movie:DataElement {
    
    let name: String
    let id: String
    let year: Int
    let runtime: Int
    let genre: String
    let director: String
    let actors: String
    let rating: Double
    let description: String
    var image: UIImage?
    let created: NSDate
    let airDate: NSDate
    var subscribersToImage = [ImageDownloadSubscriber]()
    
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
        if let url = NSURL(string: poster) {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
                if let data = NSData(contentsOfURL: url), imageFromData = UIImage(data: data) {
                    self.image = imageFromData
                    for s in self.subscribersToImage {
                        dispatch_async(dispatch_get_main_queue()) {
                            s.updateImageView()
                        }
                    }
                }
            }
        }
        
    }
    
    func subscribeToImage(subscriber: ImageDownloadSubscriber) {
        subscribersToImage.append(subscriber)
    }
    
    func getCellIdentifier() -> String {
        return "film"
    }
    
}
