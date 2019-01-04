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
        Alamofire.request(TUMCabeAPI.news(news: "")).responseJSON { [weak self] response in
            guard let self = self else { return }
            guard let json = response.result.value as? [String: Any] else { return }
            let news = News.init(entity: News.entity(), insertInto: self.context)
            
        }
    }
}
