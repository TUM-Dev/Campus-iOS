//
//  Interruption.swift
//  Abfahrt
//
//  Created by Lukas Kollmer on 13.08.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import SwiftyJSON


extension Date {
    init(millisecondsSince1970: Int) {
        self.init(timeIntervalSince1970: TimeInterval(millisecondsSince1970 / 1000))
    }
}


struct Interruption {
    let id: Int
    
    let title: String
    let text: String
    
    let lines: [Line]
    let duration: Interruption.Duration
    let link: Interruption.Link
    let modificationDate: Date
    
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        
        self.text = json["text"].stringValue
        
        self.duration = Interruption.Duration(json: json["duration"])
        
        if
            let urlString = json["links"]["link"].arrayValue.first?["link"].string,
            let urlTitle  = json["links"]["link"].arrayValue.first?["text"].string {
            self.link = Link(url: URL(string: urlString)!, title: urlTitle)
        } else {
            self.link = Link(url: URL(string: "https://www.mvg.de/dienste/betriebsaenderungen.html")!, title: "Betriebsänderungen - MVV")
        }
        
        self.modificationDate = Date(millisecondsSince1970: json["modificationDate"].intValue)
        
        
        
        // Parse lines
        
        var _lines = [Line]()
        
        for lineJSON in json["lines"]["line"].arrayValue {
            let lineNumber = Int(lineJSON["line"].stringValue.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))!
            
            let line: Line? = {
                switch lineJSON["product"].stringValue {
                case "U": return Line.ubahn(lineNumber)
                case "B": return Line.bus(lineNumber)
                case "T": return Line.tram(lineNumber)
                case "S": return Line.sbahn(lineNumber)
                default: return nil
                }
            }()
            
            if let line = line {
                _lines.append(line)
            }
        }
        
        self.lines = _lines
    }
    
}


extension Interruption {
    struct Duration {
        let start: Date
        let end: Date
        let text: String
        
        
        init(json: JSON) {
            self.start = Date(millisecondsSince1970: json["from"].intValue)
            self.end = Date(millisecondsSince1970: json["until"].intValue)
            self.text = json["text"].stringValue
        }
    }
}

extension Interruption {
    struct Link {
        let url: URL
        let title: String
    }
}
