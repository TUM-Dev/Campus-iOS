//
//  NewsSpreadManager.swift
//  Campus
//
//  Created by Mathias Quintero on 11/14/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

final class NewsSpreadManager: SourceNewsManager {
    
    typealias DataType = News
    
    unowned var newsManager: NewsManager
    
    var source: News.Source {
        return .newsSpread
    }
    
    init(newsManager: NewsManager) {
        self.newsManager = newsManager
    }
    
}
