//
//  NewsSource.swift
//  Campus
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
    static let newsspreadWeihenstephan = News.Source(identifier: 13)
    static let alumni = News.Source(identifier: 14)
    static let impulsiv = News.Source(identifier: 15)
    
    static let all = News.Source(rawValue: .max)
    
    static let newsSpread: News.Source = [
        .newsspreadFMI,
        .newsspreadChemistry,
        .newsspreadSG,
        .newsspreadWeihenstephan
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
        case .impulsiv:
            return Constants.tumBlue
        case News.Source.newsSpread:
            return .orange
        case News.Source.pressNews:
            return .blue
        case News.Source.studentNews:
            return .red
        case News.Source.tumNews:
            return Constants.tumBlue
        default:
            return Constants.newsTitleColor
        }
    }
    
    var title: String {
        switch self {
        case .movies:
            return NSLocalizedString("TU Film", comment: "")
        case .impulsiv:
            return NSLocalizedString("Impulsiv", comment: "")
        case News.Source.newsSpread:
            return NSLocalizedString("Newsspread", comment: "")
        case News.Source.pressNews:
            return NSLocalizedString("Press News", comment: "")
        case News.Source.studentNews:
            return NSLocalizedString("Student News", comment: "")
        case News.Source.tumNews:
            return NSLocalizedString("TUM News", comment: "")
        default:
            return NSLocalizedString("News", comment: "")
        }
    }
    
}
