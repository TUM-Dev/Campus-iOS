//
//  CalendarManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class CalendarManager: Manager {
    
    static var calendarItems = [DataElement]()
    
    let main: TumDataManager?
    var single = false
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    init(mainManager: TumDataManager, single: Bool) {
        main = mainManager
        self.single = single
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if CalendarManager.calendarItems.isEmpty {
            let filePath = self.getDocumentDirectory()
            let completeFilePath = filePath + "/" + XMLLocalFileResource.Calendar.rawValue + ".xml"
            let calendarXMLURL = NSURL(fileURLWithPath: completeFilePath)
            do {
                let changeDate = try NSFileManager.defaultManager().attributesOfItemAtPath(completeFilePath)["NSFileModificationDate"] as? NSDate ?? NSDate()
                if changeDate.numberOfDaysUntilDateTime(NSDate()) < 7 {
                    if let calendarFromStorage = NSData(contentsOfURL: calendarXMLURL), dataString = String(data: calendarFromStorage, encoding:NSUTF8StringEncoding) {
                        getFromXML(dataString, handler: handler)
                    } else {
                        fetchFromTUMOnline(handler)
                    }
                } else {
                    fetchFromTUMOnline(handler)
                }
            } catch {
                print("Error finding previous Calendar entries")
                fetchFromTUMOnline(handler)
            }
        } else {
            handle(handler)
        }
    }
    
    func getDocumentDirectory() -> String {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count - 1].path!
    }
    
    func fetchFromTUMOnline(handler: ([DataElement]) -> ()) {
        let url = getURL()
        Alamofire.request(.GET, url).responseString() { (response) in
            if let data = response.result.value {
                self.getFromXML(data, handler: handler)
                let filePath = self.getDocumentDirectory()
                let completeFilePath = filePath + "/" + XMLLocalFileResource.Calendar.rawValue + ".xml"
                do {
                    try data.writeToFile(completeFilePath, atomically: true, encoding: NSUTF8StringEncoding)
                } catch {
                    print("Fuck!")
                }
            }
        }
    }
    
    func getFromXML(value: String, handler: ([DataElement]) -> ()) {
        let data = SWXMLHash.parse(value)
        let events = data["events"]["event"].all
        for event in events {
            if let title = event["title"].element?.text,
                    startString = event["dtstart"].element?.text,
                    endString = event["dtend"].element?.text,
                    status = event["status"].element?.text,
                    link = event["url"].element?.text {
                
                let item = CalendarRow()
                item.title = title
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                item.dtstart = dateFormatter.dateFromString(startString)
                item.dtend = dateFormatter.dateFromString(endString)
                if let description = event["description"].element?.text {
                    item.description = description
                }
                item.status = status
                item.url = NSURL(string: link)
                if item.status == "FT" {
                    CalendarManager.calendarItems.append(item)
                }
            }
            
        }
        handle(handler)
    }
    
    func handle(handler: ([DataElement]) -> ()) {
        let onlyNew = CalendarManager.calendarItems.filter() { (item) in
            if let element = item as? CalendarRow {
                return element.dtstart?.compare(NSDate()) == NSComparisonResult.OrderedDescending
            }
            return false
        }
        if single {
            if !onlyNew.isEmpty {
                handler([onlyNew[0]])
            }
        } else {
            handler(CalendarManager.calendarItems)
        }
    }
    
    func getURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.Calendar.rawValue
        if let token = main?.getToken() {
            return base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token
        }
        return ""
    }
}