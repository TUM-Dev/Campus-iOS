//
//  BookRentalHTML.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/20/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft
import Kanna

struct BookRentalHTML {
    let html: HTMLDocument
}

extension BookRentalHTML {
    
    var csid: String? {
        return html.at_css("input[name=CSId]")?["value"]
    }
    
    var tableItems: XPathObject? {
        return html.at_css("table[class=data]")?.css("td")
    }
    
    var isMethodDone: Bool {
        return html.innerHTML?.contains("methodToCall=done") ?? false
    }
    
    var hasError: Bool {
        return html.innerHTML?.contains("error") ?? false
    }
    
    var session: BookRentalAPISession? {
        guard !hasError else {
            return nil
        }
        return BookRentalAPISession()
    }
    
    var rentals: [BookRental]? {
        guard let tableItems = tableItems else {
            return nil
        }
        if tableItems.count > 1 {
            return stride(from: 0, to: tableItems.count, by: 2).flatMap { BookRental(td1: tableItems[$0], td2: tableItems[$0 + 1]) }
        } else {
            return .empty
        }
    }
    
}

extension BookRentalHTML: DataRepresentable {
    
    init?(data: Data) {
        guard let html = Kanna.HTML(html: data, encoding: .utf8) else {
            return nil
        }
        self.init(html: html)
    }
    
}

extension API {
    
    func doHTMLRequest(with method: Sweeft.HTTPMethod = .get,
                       to endpoint: Endpoint,
                       arguments: [String:CustomStringConvertible] = .empty,
                       headers: [String:CustomStringConvertible] = .empty,
                       queries: [String:CustomStringConvertible] = .empty,
                       auth: Auth = NoAuth.standard,
                       acceptableStatusCodes: [Int] = [200],
                       completionQueue: DispatchQueue = .global(),
                       maxCacheTime: CacheTime = .no) -> BookRentalHTML.Result {
        
        return doRepresentedRequest(with: method,
                                    to: endpoint,
                                    arguments: arguments,
                                    headers: headers,
                                    queries: queries,
                                    auth: auth,
                                    acceptableStatusCodes: acceptableStatusCodes,
                                    completionQueue: completionQueue,
                                    maxCacheTime: maxCacheTime)
    }
    
}
