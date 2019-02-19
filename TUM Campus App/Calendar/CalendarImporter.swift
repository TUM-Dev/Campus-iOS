//
//  CalendarImporter.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/15/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData
import Alamofire

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
        sessionManager.request(TUMOnlineAPI.calendar(token: "")).responseXML { [weak self] xml in
            guard let strongSelf = self else { return }
            let calendar = xml.value?["events"].children.first
            print(calendar)
            try! strongSelf.context.save()
        }
    }
}
