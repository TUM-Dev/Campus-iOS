//
//  NewsManages.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsManager: Manager {
    
    static var news = [News]()
    
    var single = false
    
    required init(mainManager: TumDataManager) {
        
    }
    
    init(single: Bool) {
        self.single = single
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if NewsManager.news.isEmpty {
            if let request = getRequest() {
                Alamofire.request(request).responseJSON() { (response) in
                    if let data = response.result.value {
                        if let json = JSON(data).array {
                            for item in json {
                                let dateformatter = NSDateFormatter()
                                dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let title = item["title"].string,
                                            link = item["link"].string,
                                            dateString = item["date"].string,
                                            id = item["news"].int,
                                            date = dateformatter.dateFromString(dateString) {
                                    
                                    let image = item["image"].string
                                    let newsItem = News(id: id.description, date: date, title: title, link: link, image: image)
                                    NewsManager.news.append(newsItem)
                                }
                            }
                            self.handleNews(handler)
                        }
                    }
                }
            }
        } else {
            handleNews(handler)
        }
    }
    
    func handleNews(handler: ([DataElement]) -> ()) {
        let items = NewsManager.news.sort { (a, b) in
            return a.date.compare(b.date) == NSComparisonResult.OrderedDescending
        }
        if single {
            if let firsStory = items.first {
                handler([firsStory])
            }
        } else {
            var returnableArray = [DataElement]()
            for item in items {
                returnableArray.append(item)
            }
            handler(returnableArray)
        }
    }
    
    func getURL() -> String {
        return TumCabeApi.BaseURL.rawValue + TumCabeApi.News.rawValue
    }
    
    func getRequest() -> NSMutableURLRequest? {
        if let url = NSURL(string: getURL()), let uuid = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.setValue(uuid, forHTTPHeaderField: "X-DEVICE-ID")
            return request
        }
        return nil
    }
    
}