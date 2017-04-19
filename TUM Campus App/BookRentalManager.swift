//
//  File.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 19.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class BookRentalManager: Manager {
    
    let user = ""
    let password = ""
    let opac_url = "https://opac.ub.tum.de/InfoGuideClient.tumsis"
    var CSId = ""
    let startparams = "Login=wotum01"
    var sessionLifetime = TimeInterval(20 * 60 * 1000)
    var sessionStart: Date?
    var sessionEnd: Date?
    
    var main: TumDataManager
    
    var handler: (([DataElement]) -> ())?
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }

    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {

        startSession()
        
    }
    
    func startSession() {
        
        Alamofire.request(opac_url+"/start.do?"+startparams).responseString { response in
            if let html = response.result.value {
                if let doc = Kanna.HTML(html: html, encoding: .utf8) {
                    if let input = doc.at_css("input[name=CSId]") {
                        self.CSId = input["value"]!
                        print("Got Session ID: \(self.CSId)")
                        self.login()
                    }
                }
            }
        }
    }
    
    func login() {
        
        let params = [
            "username" : user,
            "password" : password,
            "CSId" : CSId,
            "methodToCall" : "submit"
        ]
        
        Alamofire.request(opac_url + "/login.do?", method: .post, parameters: params).responseString { response in
            
            print("Doing request with: \(response.request!.httpMethod!) - \(response.request!.url!.absoluteString)\n\(response.request!.httpBody.map { body in String(data: body, encoding: .utf8) ?? "" } ?? "")")
            
            if let html = response.result.value {
                if let doc = Kanna.HTML(html: html, encoding: .utf8) {
                    if doc.innerHTML!.contains("methodToCall=done")  {
                        Alamofire.request(self.opac_url+"/login.do?methodToCall=done").responseString {
                            rsp in
                            self.handleLogin(html: rsp.result.value!)
                        }
                    } else {
                        self.handleLogin(html: response.result.value!)
                    }
                }
            }
        }
    }
    
    func handleLogin(html: String) {
        
        if let finalDoc = Kanna.HTML(html: html, encoding: .utf8) {
            if finalDoc.innerHTML!.contains("error") {
                print("error")
            } else {
                let div = finalDoc.at_css("div[id=login]")!
                let bibNum = div.at_xpath("text()[2]")!.content!
                print("logged in as:\(bibNum)")
                sessionStart = Date()
                sessionEnd = sessionStart?.addingTimeInterval(sessionLifetime)
                getRentals()
            }
        }
    }
    
    func getRentals() {
        
        Alamofire.request(opac_url+"/userAccount.do?methodToCall=showAccount&typ=1").responseString { response in
            if let html = response.result.value {
                if let doc = Kanna.HTML(html: html, encoding: .utf8) {
                    if let table = doc.at_css("table[class=data]") {
                        
                        let tds = table.css("td")
                        
                        for index in stride(from: 0, to: tds.count, by: 2) {
                            
                            let td1 = tds[index]
                            let td2 = tds[index+1]
                            
                            let title = td1.at_css("strong")?.content
                            let author = td1.at_xpath("text()[2]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines)
                            let id = td1.at_xpath("text()[3]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines)
                            let deadline = td2.at_xpath("text()[1]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines)
                            let bib = td2.at_xpath("text()[2]")?.content?.trimmingCharacters(in: .whitespacesAndNewlines)
                            let prolong = td1.at_css("span[class]")?.content
                            
                            print(title)
                            print(author)
                            print(id)
                            print(deadline)
                            print(bib)
                            print(prolong)
                            print("-----------------")
                        }
                    }
                }
            }
        }
    }
}


struct Rental {
    
    var title: String
    var author: String
    var imageURL: String
    var deadline: Date
    var prolongPossible: ProlongPossibilty
}

enum ProlongPossibilty: String {
    
    case notYetPossible = "Eine Verlängerung ist noch nicht möglich."
    case possible = "?" //we still need to find out this string
    case notPossible = "??" //we still need to find out this string
}
