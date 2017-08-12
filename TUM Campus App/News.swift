//
//  News.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit
import SafariServices

class News: ImageDownloader, DataElement {
    
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
    
    func open(sender: UIViewController? = nil) {
        guard let url = URL(string: link) else { return }
        
        if let sender = sender {
            let safariViewController = SFSafariViewController(url: url)
            sender.present(safariViewController, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension News: CardDisplayable {
    
    var cardKey: CardKey {
        return .news
    }
  
}

extension News: Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}
