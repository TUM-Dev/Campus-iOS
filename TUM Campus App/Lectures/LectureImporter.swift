//
//  LectureImporter.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import XMLParsing

class LectureImporter {
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
    
    func fetchLectures() {
        sessionManager.request(TUMOnlineAPI.personalLectures(token: "")).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.data else { return }
            let decoder = XMLDecoder()
            decoder.userInfo[.context] = self.context
            
            let lectures = try! decoder.decode(Lectures.self, from: data)
            print(lectures.lectures)
            try! self.context.save()
        }
    }
}
