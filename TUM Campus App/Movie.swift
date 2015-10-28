//
//  Movie.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class Movie {
    
    let name: String
    var image: UIImage?
    let airDate: NSDate
    
    init() {
        name = "Jagd auf Roter Oktober"
        image = UIImage(named: "film")
        airDate = NSDate()
    }
    
}
