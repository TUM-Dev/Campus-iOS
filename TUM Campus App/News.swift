//
//  News.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class News: ImageDownloader, DataElement {
    
    let id: String
    let date: NSDate
    let title: String
    let link: String
    
    init(id: String, date: NSDate, title: String, link: String, image: String? = nil) {
        self.id = id
        self.date = date
        self.title = title
        self.link = link
        super.init()
        if let image = image?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()) {
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
        if let url = NSURL(string: link) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}