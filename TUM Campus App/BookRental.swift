//
//  BookRental.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 19.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation


class BookRental: DataElement {
    
    let title: String
    let author: String
    let id: String
    let deadline: String
    let bib: String
    let prolong: String
    
    init(title: String, author: String, id: String, deadline: String, bib: String, prolong: String) {
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

extension BookRenal: CardDisplayable {
    
    var cardKey: CardKey {
        return .bookRental
    }
}
