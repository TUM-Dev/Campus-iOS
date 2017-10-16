//
//  BookRetanlAPI.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/20/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

struct BookRentalAPI: API {
    
    enum Endpoint: String, APIEndpoint {
        case start = "start.do"
        case login = "login.do"
        case rentals = "userAccount.do"
    }
    
    let baseURL: String
    
}

extension BookRentalAPI {
    
    func start() -> String.Result {
        return doHTMLRequest(to: .start, queries: ["Login": "wotum01"]).flatMap { document in
            return document.csid.map { .successful(with: $0) } ?? .errored(with: .noData)
        }
    }
    
    func login(user: String, password: String, csid: String) -> Response<BookRentalAPISession> {
        let queries = [
            "username": user,
            "password": password,
            "CSId": csid,
            "methodToCall" : "submit"
        ]
        return doHTMLRequest(with: .post, to: .login, queries: queries).flatMap { document in
            
            if document.isMethodDone {
                return self.loadLogin()
            } else {
                return document.session.map { .successful(with: $0) } ?? .errored(with: .noData)
            }
        }
    }
    
    func loadLogin() -> Response<BookRentalAPISession> {
        return doHTMLRequest(to: .login, queries: ["methodToCall": "done"]).flatMap { document in
            
            return document.session.map { .successful(with: $0) } ?? .errored(with: .noData)
            
        }
    }
    
    func rentals() -> Response<[BookRental]> {
        return doHTMLRequest(to: .rentals, queries: ["methodToCall": "showAccount", "typ": 1]).flatMap { document in
            
            return document.rentals.map { .successful(with: $0) } ?? .errored(with: .noData)
        }
    }
    
}
