//
//  CalendarImporter.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/15/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData
import Alamofire
import XMLParsing

class CalendarImporter {
    var context: NSManagedObjectContext
    lazy var sessionManager: SessionManager = {
        let manager = SessionManager()
        manager.adapter = AuthenticationHandler(delegate: nil)
        manager.retrier = AuthenticationHandler(delegate: nil)
        return manager
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchEvents() {
        sessionManager.request(TUMOnlineAPI.calendar(token: "")).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.data else { return }
            let decoder = XMLDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddhhmmss)
            decoder.userInfo[.context] = self.context

            let calendar = try! decoder.decode(Calendar.self, from: data)
            print(calendar.events)
            try! self.context.save()
        }
    }
}
