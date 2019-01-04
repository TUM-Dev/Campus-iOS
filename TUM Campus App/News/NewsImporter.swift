//
//  NewsImporter.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/4/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData
import Alamofire

class NewsImporter {
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchNews() {
        Alamofire.request(TUMCabeAPI.news(news: "")).responseJSON { response in
            response.value
        }
    }
}
