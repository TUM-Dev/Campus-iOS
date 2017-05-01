//
//  News.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

import Sweeft

final class News: ImageDownloader, DataElement {
    
    let id: String
    let date: Date
    let title: String
    let link: String
    
    init(id: String, date: Date, title: String, link: String, image: String? = nil) {
        self.id = id
        self.date = date
        self.title = title
        self.link = link
        super.init()
        if let image = image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) {
            getImage(image)
        }
    }
    
    var text: String {
        get {
            return title
        }
    }
    
    func getCellIdentifier() -> String {
        return "news"
    }
    
    func open() {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension News: CardDisplayable {
    
    var cardKey: CardKey {
        return .news
    }
  
}

extension News: Deserializable {
    
    convenience init?(from json: JSON) {
        guard let title = json["title"].string,
            let link = json["link"].string,
            let date = json["date"].date(using: "yyyy-MM-dd HH:mm:ss"),
            let id = json["news"].string else {
                
            return nil
        }
        self.init(id: id, date: date, title: title, link: link)
    }
    
}

extension News: Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}
