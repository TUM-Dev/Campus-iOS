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
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if NewsManager.news.isEmpty {
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                Alamofire.request(getURL(), method: .get, parameters: nil,
                                  headers: ["X-DEVICE-ID": uuid]).responseJSON() { (response) in
                    if let data = response.result.value {
                        if let json = JSON(data).array {
                            for item in json {
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let title = item["title"].string,
                                            let link = item["link"].string,
                                            let dateString = item["date"].string,
                                            let id = item["news"].string,
                                            let date = dateformatter.date(from: dateString) {
                                    
                                    let image = item["image"].string
                                    let newsItem = News(id: id, date: date, title: title, link: link, image: image)
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
    
    func handleNews(_ handler: ([DataElement]) -> ()) {
        let items = NewsManager.news.sorted { (a, b) in
            return a.date.compare(b.date as Date) == ComparisonResult.orderedDescending
        }
        if single {
            handler([getNextUpcomingNews()])
        } else {
            var returnableArray = [DataElement]()
            for item in items {
                returnableArray.append(item)
            }
            handler(returnableArray)
        }
    }
    
    func getNextUpcomingNews() -> News {
        let now = Date()
        for (index, item) in NewsManager.news.enumerated() {
            if item.date < now  {
                return NewsManager.news[index-1]
            }
        }
        return NewsManager.news[0] // There are only past news
    }
    
    func getURL() -> String {
        return TumCabeApi.BaseURL.rawValue + TumCabeApi.News.rawValue
    }
    
}
