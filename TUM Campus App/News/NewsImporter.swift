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
        Alamofire.request(TUMCabeAPI.news(news: "")).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddhhmmss)
            decoder.userInfo[.context] = self.context
            let news = try! decoder.decode([News].self, from: data)
            print(news)
            try! self.context.save()
        }
    }
}
