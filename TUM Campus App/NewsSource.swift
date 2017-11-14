//
//  NewsSource.swift
//  Campus
//
//  Created by Mathias Quintero on 11/14/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

extension News {
    
    struct Source: OptionSet {
        let rawValue: Int
    }
    
}

extension News.Source {
    
    init(identifier: Int) {
        self.init(rawValue: 1 << (identifier - 1))
    }
    
    static let tumNews = News.Source(identifier: 1)
    static let movies = News.Source(identifier: 2)
    static let studentNews = News.Source(identifier: 4)
    static let pressNews = News.Source(identifier: 5)
    static let operatingSystems = News.Source(identifier: 6)
    static let newsspreadFMI = News.Source(identifier: 7)
    static let newsspreadChemistry = News.Source(identifier: 8)
    static let newsspreadSG = News.Source(identifier: 9)
    static let newsspreadWI = News.Source(identifier: 10)
    static let newsspreadPhysics = News.Source(identifier: 11)
    static let newsspreadLab = News.Source(identifier: 12)
    static let newsspreadWeihenstephan = News.Source(identifier: 13)
    static let alumni = News.Source(identifier: 14)
    static let impulsiv = News.Source(identifier: 15)
    
    static let all = News.Source(rawValue: .max)
    
    static let newsSpread: News.Source = [
        .newsspreadFMI,
        .newsspreadChemistry,
        .newsspreadSG,
        .newsspreadWI,
        .newsspreadPhysics,
        .newsspreadLab,
        .newsspreadWeihenstephan,
        ]
    
    static var restOfNews: News.Source {
        return News.Source.all.subtracting([.movies, .newsSpread])
    }
    
}

extension News.Source {
    
    var titleColor: UIColor {
        switch self {
        case .movies:
            return Constants.tuFilmTitleColor
        default:
            return Constants.newsTitleColor
        }
    }
    
    var title: String {
        switch self {
        case .movies:
            return "TU Film"
        default:
            return "News"
        }
    }
    
}
