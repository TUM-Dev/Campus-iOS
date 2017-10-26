//
//  UserDataManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft
import SWXMLHash

final class UserDataManager: DetailsForDataManager {
    
    typealias DataType = User
    typealias ResponseType = UserData
    
    let config: Config
    
    init(config: Config) {
        self.config = config
    }
    
    func search(with id: String) -> Response<UserData> {
        let manager = PersonSearchManager(config: config)
        return manager.search(query: id).flatMap { users in
            guard let user = users.first, users.count == 1 else {
                return .errored(with: .noData)
            }
            return .successful(with: user)
        }
    }
    
    func fetch() -> Response<User> {
        return config.tumOnline.user.map { user in
            return self.fetch(for: user).map { (data: UserData) in
                user.data = data
                return user
            }
        } ?? .errored(with: .cannotPerformRequest)
    }
    
    func fetch(for data: User) -> Response<UserData> {
        guard let name = data.name else {
            return config.tumOnline.doRepresentedRequest(to: .identify).flatMap { (xml: XMLIndexer) in
                
                guard let first = xml.get(at: ["rowset", "row", "vorname"])?.element?.text,
                    let last = xml.get(at: ["rowset", "row", "familienname"])?.element?.text else {
                        
                    return .errored(with: .cannotPerformRequest)
                }
                let name = "\(first) \(last)"
                data.name = name
                return self.search(with: name)
            }
        }
        return search(with: name)
    }

}
