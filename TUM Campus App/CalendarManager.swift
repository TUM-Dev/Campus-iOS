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
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if CalendarManager.calendarItems.isEmpty {
            let filePath = self.getDocumentDirectory()
            let completeFilePath = filePath + "/" + XMLLocalFileResource.Calendar.rawValue + ".xml"
            let calendarXMLURL = URL(fileURLWithPath: completeFilePath)
            do {
                let changeDate = try FileManager.default.attributesOfItem(atPath: completeFilePath)[FileAttributeKey.modificationDate] as? Date ?? Date()
                if changeDate.numberOfDaysUntilDateTime(Date()) < 7 {
                    if let calendarFromStorage = try? Data(contentsOf: calendarXMLURL), let dataString = String(data: calendarFromStorage, encoding:String.Encoding.utf8) {
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
        let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        return urls[urls.count - 1].path
    }
    
    func fetchFromTUMOnline(_ handler: @escaping ([DataElement]) -> ()) {
        let url = getURL()
        Alamofire.request(url).responseString() { (response) in
            if let data = response.result.value {
                self.getFromXML(data, handler: handler)
                let filePath = self.getDocumentDirectory()
                let completeFilePath = filePath + "/" + XMLLocalFileResource.Calendar.rawValue + ".xml"
                do {
                    try data.write(toFile: completeFilePath, atomically: true, encoding: .utf8)
                } catch {
                    print("Fuck!")
                }
            }
        }
    }
    
    func getFromXML(_ value: String, handler: ([DataElement]) -> ()) {
        let data = SWXMLHash.parse(value)
        let events = data["events"]["event"].all
        for event in events {
            if let title = event["title"].element?.text,
                    let startString = event["dtstart"].element?.text,
                    let endString = event["dtend"].element?.text,
                    let status = event["status"].element?.text,
                    let link = event["url"].element?.text,
                let location = event["location"].element?.text {
                
                let item = CalendarRow()
                item.title = title
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                item.dtstart = dateFormatter.date(from: startString)
                item.dtend = dateFormatter.date(from: endString)
                if let description = event["description"].element?.text {
                    item.description = description
                }
                item.status = status
                item.url = URL(string: link)
                item.location = location
                if item.status == "FT" {
                    CalendarManager.calendarItems.append(item)
                }
            }
            
        }
        handle(handler)
    }
    
    func handle(_ handler: ([DataElement]) -> ()) {
        let onlyNew = CalendarManager.calendarItems.filter { (item: DataElement) in
            if let element = item as? CalendarRow {
                return element.dtstart?.compare(Date()) == ComparisonResult.orderedDescending
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
