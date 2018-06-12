//
//  BookRental.swift
//  TUM Campus App
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
import Kanna

class BookRental: DataElement {
    
    let title: String
    let author: String
    let id: String
    let deadline: String
    let bib: String
    let prolong: ProlongPossibilty
    
    enum ProlongPossibilty: String {
        case notYetPossible = "Eine Verlängerung ist noch nicht möglich."
        case possible = "?" //we still need to find out this string
        case notPossible = "??" //we still need to find out this string
    }
    
    init(title: String, author: String, id: String, deadline: String, bib: String, prolong: ProlongPossibilty) {
        self.title = title
        self.author = author
        self.id = id
        self.deadline = deadline
        self.bib = bib
        self.prolong = prolong
    }
    
    func getCellIdentifier() -> String {
        return "bookRental"
    }
    
    var text: String {
        return title
    }
}

extension BookRental {
    
    convenience init?(td1: XMLElement, td2: XMLElement) {
        guard let title = td1.at_css("strong")?.content,
            let author = td1.at_xpath("text()[2]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines),
            let id = td1.at_xpath("text()[3]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines),
            let deadline = td2.at_xpath("text()[1]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines),
            let bib = td2.at_xpath("text()[2]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines),
            let prolong = ProlongPossibilty(tableItem: td1) else {
                return nil
        }
        self.init(title: title, author: author, id: id, deadline: deadline, bib: bib, prolong: prolong)
    }
    
}

extension BookRental.ProlongPossibilty {
    
    init?(tableItem: XMLElement) {
        guard let rawValue = tableItem.at_css("span[class]")?.content,
            let value = BookRental.ProlongPossibilty.init(rawValue: rawValue) else {
            return nil
        }
        self = value
    }
    
}
