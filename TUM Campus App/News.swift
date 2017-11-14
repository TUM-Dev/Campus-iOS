//
//  News.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

final class News: DataElement {
    
    let id: String
    let source: Source
    let date: Date
    let title: String
    let link: String
    let image: Image
    
    init(id: String, source: Source, date: Date, title: String, link: String, image: String? = nil) {
        self.id = id
        self.source = source
        self.date = date
        self.title = title
        self.link = link
        self.image = .init(url: image)
    }
    
    var text: String {
        get {
            return title
        }
    }
    
    func getCellIdentifier() -> String {
        return "news"
    }
    
    func open(sender: UIViewController? = nil) {
        link.url?.open(sender: sender)
    }
    
}

extension News: Deserializable {
    
    convenience init?(from json: JSON) {
        guard let title = json["title"].string,
            let source = json["src"].string.flatMap(Int.init).map(News.Source.init(identifier:)),
            let link = json["link"].string,
            let date = json["date"].date(using: "yyyy-MM-dd HH:mm:ss"),
            let id = json["news"].string else {
                
            return nil
        }
        self.init(id: id, source: source, date: date, title: title, link: link, image: json["image"].string)
    }
    
}

extension News: Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}
