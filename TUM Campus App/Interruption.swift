//
//  Interruption.swift
//  Abfahrt
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

import Foundation
import Sweeft

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
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let title = json["title"].string,
            let text = json["text"].string,
            let duration = Interruption.Duration(json: json["duration"]),
            let modificationDate = json["modificationDate"].int else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.text = text
        self.duration = duration
        
        if let urlString = json["links"]["link"].array?.first?["link"].string,
            let urlTitle  = json["links"]["link"].array?.first?["text"].string {
            self.link = Link(url: URL(string: urlString)!, title: urlTitle)
        } else {
            self.link = Link(url: URL(string: "https://www.mvg.de/dienste/betriebsaenderungen.html")!,
                             title: "Betriebsänderungen - MVV")
        }
        
        self.modificationDate = Date(millisecondsSince1970: modificationDate)
        
        // Parse lines
        
        var _lines: [Line] = []
        
        for lineJSON in json["lines"]["line"].array.? {
            let lineNumber = Int(lineJSON["line"].string!.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))!
            
            let line: Line? = {
                switch lineJSON["product"].string {
                case .some("U"): return Line.ubahn(lineNumber)
                case .some("B"): return Line.bus(lineNumber)
                case .some("T"): return Line.tram(lineNumber)
                case .some("S"): return Line.sbahn(lineNumber)
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
        
        init?(json: JSON) {
            guard let from = json["from"].int,
                let until = json["until"].int,
                let text = json["text"].string else {
                    
                return nil
            }
            self.start = Date(millisecondsSince1970: from)
            self.end = Date(millisecondsSince1970: until)
            self.text = text
        }
    }
}

extension Interruption {
    struct Link {
        let url: URL
        let title: String
    }
}
