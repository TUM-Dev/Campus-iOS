//
//  TUFilmNewsManager.swift
//  Campus
//
//  Created by Mathias Quintero on 11/13/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

final class TUFilmNewsManager: SourceNewsManager {
    
    typealias DataType = News
    
    unowned var newsManager: NewsManager
    
    var cardKey: CardKey {
        return .tufilm
    }
    
    var source: News.Source {
        return .movies
    }
    
    init(newsManager: NewsManager) {
        self.newsManager = newsManager
    }
    
}
